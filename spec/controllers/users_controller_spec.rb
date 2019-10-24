require 'rails_helper'

describe UsersController, type: :controller do

  describe 'POST #create' do

    context 'When creating a valid user' do
      before do
        post :create, params: { user: attributes_for(:user) }
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the created user in the body' do
        expect(response_body).to eq({ user: UserSerializer.new(User.last).attributes }.as_json)
      end
    end

    context 'When user is invalid' do
      before do
        post :create, params: { user: attributes_for(:user, email: 'nico.com') }
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
    let!(:users) { create_list(:user, 7) }

    context 'when no pagination specified' do 
      before { get :index }

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of users with default pagination' do
        expect(response_body['users'].length).to be Kaminari.config.default_per_page
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

      it 'returns 3th and 4th user' do 
        expect(response_body['users']).to eq [users[2], users[3]].map { |user| UserSerializer.new(user).attributes.as_json }
      end
    end
  end


  describe 'GET #show' do

    context 'When fetching an existing user' do
      let!(:user) { create(:user) }

      before { get :show, params: { id: user.id } }

      it 'returns ok status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user in the body' do
        expect(response_body).to eq({ user: UserSerializer.new(user).attributes }.as_json)
      end
    end

    context 'When user doesnt exist' do
      before { get :show, params: { id: 1 } }

      it 'returns not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
