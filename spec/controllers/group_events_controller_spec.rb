require 'rails_helper'

describe GroupEventsController, type: :controller do

  let(:creator) { create(:user) }

  describe 'POST #create' do

	  context 'When creating a valid event' do
	    before do
	      post :create, params: attributes_for(:group_event, creator_id: creator.id)
	    end

	    it 'returns created status' do
	      expect(response).to have_http_status(:created)
	    end

	    it 'returns the group event' do
        expected_serialization = {
          id: root_tree_node.external_id, child: [
            { id: tree_node_child_1.external_id, child: [] },
            { id:  tree_node_child_2.external_id, child: [
              { id: tree_node_child_3.external_id, child: [] }
            ]}
          ]
        }
	      expect(response_body).to eq expected_serialization.as_json
	    end
	  end

    context 'When asking for an unexisting Tree' do
      before do
        get :show, params: { tree_id: 999 }
      end

      it 'returns 404 (Not Found)' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a message indicating the error' do 
      	expect(response_body).to eq({ error: "Tree with id 999 doesnt exist" }.as_json)
      end
    end
	end

  describe 'GET #parent' do

	  context 'When asking for an existing tree and an existing node' do
	    before do
	      get :parent, params: { tree_id: root_tree_node.external_id, id: tree_node_child_3.external_id }
	    end

	    it 'returns 200' do
	      expect(response).to have_http_status(:ok)
	    end

	    it 'returns list of ancestor ids' do
	    	expected_response = { parent_ids: [root_tree_node.external_id, tree_node_child_2.external_id] }
	      expect(response_body).to eq expected_response.as_json
	    end
	  end

    context 'When asking for an unexisting Tree' do
      before do
        get :parent, params: { tree_id: 999, id: tree_node_child_3.external_id }
      end

      it 'returns 404 (Not Found)' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a message indicating the error' do 
      	expect(response_body).to eq({ error: "Tree with id 999 doesnt exist" }.as_json)
      end
    end

    context 'When asking for an unexisting TreeNode' do
      before do
        get :parent, params: { tree_id: root_tree_node.external_id, id: 123 }
      end

      it 'returns 404 (Not Found)' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a message indicating the error' do 
      	expect(response_body).to eq(
      		{ error: "Node with id 123 in Tree #{root_tree_node.external_id} doesnt exist" }.as_json
      	)
      end
    end
	end

  describe 'GET #child' do

	  context 'When asking for an existing tree and an existing node' do
	    before do
	      get :child, params: { tree_id: root_tree_node.external_id, id: tree_node_child_2.external_id }
	    end

	    it 'returns 200' do
	      expect(response).to have_http_status(:ok)
	    end

	    it 'returns the serialized node' do
        expected_serialization = {
          id: tree_node_child_2.external_id, child: [
            { id: tree_node_child_3.external_id, child: [] }
          ]
        }
	      expect(response_body).to eq expected_serialization.as_json
	    end
	  end

    context 'When asking for an unexisting Tree' do
      before do
        get :child, params: { tree_id: 999, id: tree_node_child_3.external_id }
      end

      it 'returns 404 (Not Found)' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a message indicating the error' do 
      	expect(response_body).to eq({ error: "Tree with id 999 doesnt exist" }.as_json)
      end
    end

    context 'When asking for an unexisting TreeNode' do
      before do
        get :child, params: { tree_id: root_tree_node.external_id, id: 123 }
      end

      it 'returns 404 (Not Found)' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a message indicating the error' do 
      	expect(response_body).to eq(
      		{ error: "Node with id 123 in Tree #{root_tree_node.external_id} doesnt exist" }.as_json
      	)
      end
    end
	end
end