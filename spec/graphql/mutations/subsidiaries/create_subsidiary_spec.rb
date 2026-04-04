# spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb

require 'rails_helper'

RSpec.describe 'Create Subsidiary Mutation', type: :graphql do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:corporation) { FactoryBot.create(:corporation) }
  let(:status) { FactoryBot.create(:status) }
  let(:subsidiary) { FactoryBot.create(:subsidiary, corporation: corporation, status: status) }
  let(:input) { { input: { name: 'Subsidiary Name' } } }
  let(:mutation) { "mutation { createSubsidiary(input: #{input}) { subsidiary { id, name, phone, address, email, status, corporation { id, name } } } }" }

  context 'admin user can create a Subsidiary successfully' do
    it 'returns a valid Subsidiary' do
      post '/graphql', params: { query: mutation }
      expect(response).to have_http_status(:success)
      expect(subsidiary.reload).to be_a(Subsidiary)
    end
  end

  context 'non-admin user gets an Unauthorized error' do
    it 'returns an Unauthorized error' do
      post '/graphql', params: { query: mutation, headers: { Authorization: user.authentication_token } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'missing required fields return validation errors' do
    it 'returns validation errors' do
      post '/graphql', params: { query: mutation, headers: { Authorization: admin.authentication_token } }
      expect(response).to have_http_status(:bad_request)
    end
  end
end