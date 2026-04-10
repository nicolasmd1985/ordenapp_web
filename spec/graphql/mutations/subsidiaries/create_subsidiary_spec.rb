require 'rails_helper'

RSpec.describe CreateSubsidiary, type: :request do
  describe 'admin user' do
    it 'creates a Subsidiary' do
      user = create(:admin_user)
      post '/graphql', params: { query: { mutation: 'createSubsidiary', variables: { name: 'New Subsidiary', status_id: Status.first.id, corporation_id: Corporation.first.id } } }
      expect(response).to have_http_status(:ok)
      expect(json['data']['createSubsidiary']).to be_present
    end

    it 'returns unauthorized error for non-admin user' do
      user = create(:user)
      post '/graphql', params: { query: { mutation: 'createSubsidiary', variables: { name: 'New Subsidiary', status_id: Status.first.id, corporation_id: Corporation.first.id } } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns validation errors for missing required fields' do
      user = create(:admin_user)
      post '/graphql', params: { query: { mutation: 'createSubsidiary', variables: { name: '', status_id: Status.first.id, corporation_id: Corporation.first.id } } }
      expect(response).to have_http_status(:bad_request)
      expect(json['data']['createSubsidiary']).to be_nil
    end
  end
end