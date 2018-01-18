require 'rails_helper'

RSpec.describe PanelController, type: :controller do
  let!(:organization) { FactoryBot.create(:organization, id: Organization::ID_TEST) }

  it 'renders the index view' do
    get :index
    expect(response).to render_template :index
    expect(assigns(:organization)).to be_a_kind_of(Organization)
  end

  context 'when fetching data' do
    context 'with a success call' do
      it 'returns a organization' do
        RestClient = double
        rest_response = double
        rest_response.stub(:code) { 200 }
        rest_response.stub(:body) { '{"data":{"organization":{}}}' }
        RestClient.stub(:post) { rest_response }
        post :fetch_data
        expect(response).to redirect_to(root_path)
        expect(flash[:warning]).to be_nil
      end
    end

    context 'with a failed call' do
      it 'returns a message' do
        RestClient = double
        rest_response = double
        rest_response.stub(:code) { 400 }
        rest_response.stub(:body) { '{"errors":[{"message":"Custom Error"}]}' }
        RestClient.stub(:post) { rest_response }
        post :fetch_data
        expect(response).to redirect_to(root_path)
        expect(flash[:warning]).to eq(I18n.t('.error', code: 400))
      end
    end
  end
end