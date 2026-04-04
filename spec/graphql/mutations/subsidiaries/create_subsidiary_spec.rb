require 'rails_helper'

RSpec.describe GraphQL::Subsidiaries::CreateSubsidiary, type: :request do
  describe 'admin user' do
    let(:admin_user) { create(:user, role: :admin) }
    let(:headers) { admin_user.create_new_session[:session].headers }
    let(:params) do
      { input: { name: 'Subsidiary Test', status_id: 1, corporation_id: 1 } }
    end

    it 'creates a Subsidiary successfully' do
      post '/graphql', params: params, headers: headers
      expect(response).to have_http_status(:created)
      expect(json_response).to have_key(:data)
      expect(json_response[:data]).to have_key(:createSubsidiary)
      expect(json_response[:data][:createSubsidiary]).to be_truthy
    end

    it 'returns an Unauthorized error for non-admin user' do
      post '/graphql', params: params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns validation errors for missing required fields' do
      params[:input].merge(name: '', status_id: 1, corporation_id: 1)
      post '/graphql', params: params, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key(:errors)
    end
  end
end