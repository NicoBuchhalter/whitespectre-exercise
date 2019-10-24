require 'rails_helper'

describe GroupEventsController, type: :controller do

  let(:creator) { create(:user) }
  let(:today) { Date.today }
  let(:duration) { 3 }

  describe 'POST #create' do

	  context 'When creating a valid event' do
	    before do
	      post :create, params: { group_event: attributes_for(:group_event, creator_id: creator.id) }
	    end

	    it 'returns create status' do
	      expect(response).to have_http_status(:created)
	    end

      it 'returns the created event in the body' do
        expect(response_body).to eq({ group_event: GroupEventSerializer.new(GroupEvent.last).as_json }.as_json)
      end
    end

    context 'when passing only start_date and duration' do
      before do
        post :create, params: { 
          group_event: attributes_for(:group_event, start_date: today, end_date: nil, duration: duration, creator_id: creator.id) 
        }
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'sets end_date correctly' do
        expect(response_body['group_event']['end_date']).to eq (today + duration.days).to_s
      end
    end

    context 'when passing only end_date and duration' do

      before do
        post :create, params: { 
          group_event: attributes_for(:group_event, end_date: today, start_date: nil, duration: duration, creator_id: creator.id) 
        }
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'sets start_date correctly' do
        expect(response_body['group_event']['start_date']).to eq (today - duration.days).to_s
      end
    end

    context 'When group_event is invalid' do
      before do
        post :create, params: { group_event: attributes_for(:group_event, creator_id: nil) }
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error in body' do 
        expect(response_body['errors']).to be_present
      end
    end
  end

  describe 'GET #index' do
    let!(:group_events) { create_list(:group_event, 7) }

    context 'when no pagination specified' do 
      before { get :index }

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of group_events with default pagination' do
        expect(response_body['group_events'].length).to be Kaminari.config.default_per_page
      end

      it 'includes meta pagination data' do
        expect(response_body['meta']['total_count']).to be 7
      end
    end

    context 'When pagination params provided' do
      before do
        post :index, params: { page: 2, per_page: 2 }
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns 3th and 4th group_event' do 
        expect(response_body['group_events']).to eq(
          [group_events[2], group_events[3]].map { |group_event| GroupEventSerializer.new(group_event).as_json }.as_json
        )
      end
    end
  end

  describe 'GET #show' do

    context 'When fetching an existing group_event' do
      let!(:group_event) { create(:group_event) }

      before do
        get :show, params: { id: group_event.id }
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the group_event in the body' do
        expect(response_body).to eq({ group_event: GroupEventSerializer.new(group_event).as_json }.as_json)
      end
    end

    context 'When group_event doesnt exist' do
      before do
        get :show, params: { id: 1 }
      end

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do

    context 'When updating an existing group_event' do
      let!(:group_event) { create(:group_event) }

      context 'and update is valid' do 
        new_name = 'A new name'

        before do
          put :update, params: { id: group_event.id, group_event: { name: new_name } }
        end

        it 'returns ok status' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns the updated group_event in the body' do
          expect(response_body['group_event']['name']).to eq new_name
        end
      end

      context 'and updating end_date and duration' do 
        before do
          put :update, params: {
            id: group_event.id, group_event: { end_date: today, start_date: nil, duration: duration }
          }
        end

        it 'returns ok status' do
          expect(response).to have_http_status(:ok)
        end

        it 'sets start_date correctly' do
          expect(response_body['group_event']['start_date']).to eq (today - duration.days).to_s
        end        
      end

      context 'and updating start_date and duration' do 
        before do
          put :update, params: { 
            id: group_event.id, group_event: {
              end_date: nil, start_date: today, duration: duration
            }
          }
        end

        it 'returns ok status' do
          expect(response).to have_http_status(:ok)
        end

        it 'sets start_date correctly' do
          expect(response_body['group_event']['end_date']).to eq (today + duration.days).to_s
        end        
      end

      context 'and update fails' do
        before do
          put :update, params: { 
            id: group_event.id, group_event: {
              start_date: Date.tomorrow, end_date: Date.today 
            }
          }
        end

        it 'returns bad request status' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns errors in body' do 
          expect(response_body['errors']).to be_present
        end
      end
    end

    context 'When group_event doesnt exist' do
      before do
        put :update, params: { id: 1 }
      end

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #publish' do 

    context 'When event is ready to be published' do 
      let!(:group_event) { create(:group_event) }

      before { post :publish, params: { id: group_event.id } }
      
      it 'marks the event as published' do
        expect(group_event.reload.published).to be true
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the event in body' do
        expect(response_body).to eq({ group_event: GroupEventSerializer.new(group_event.reload).as_json }.as_json)
      end
    end

    context 'When it has missing requred. attributes for publishing' do 
      let!(:group_event) { create(:group_event, location: nil) }

      before { post :publish, params: { id: group_event.id } }
      
      it 'doesnt mark the event as published' do
        expect(group_event.reload.published).to be false
      end

      it 'returns bad request status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the error in body' do
        expect(response_body['error']).to eq 'Event needs to have all of required fields to be published'
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'When destroying an existing group_event' do
      let!(:group_event) { create(:group_event) }

      before do
        delete :destroy, params: { id: group_event.id }
      end

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'marks the event as discarded' do
        expect(group_event.reload.discarded_at).to be_present
      end
    end

    context 'When group_event doesnt exist' do
      before do
        delete :destroy, params: { id: 1 }
      end

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end