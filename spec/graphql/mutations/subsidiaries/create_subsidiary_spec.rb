require 'rails_helper'

RSpec.describe Mutations::Subsidiaries::CreateSubsidiary, type: :request do
  let!(:status_100) { Status.find_by(id: 100) || create(:status, id: 100, type_status: "General", description: "Active") }
  let(:password) { "Password123!" }
  let(:admin_user) { create(:user, role: :admin, password: password) }
  let(:regular_user) { create(:user, role: :tecnic, password: password) }
  
  # Generate JWT tokens using the application's JsonWebToken helper
  let(:admin_token) { JsonWebToken.encode(user_id: admin_user.id) }
  let(:regular_token) { JsonWebToken.encode(user_id: regular_user.id) }

  let(:mutation) do
    <<~GQL
      mutation CreateSubsidiary($input: CreateSubsidiaryInput!) {
        createSubsidiary(input: $input) {
          subsidiary {
            id
            name
            email
          }
          errors
        }
      }
    GQL
  end

  let(:subsidiary_attributes) do
    {
      name: 'New Subsidiary',
      phone: '123456789',
      address: 'Some Address',
      email: "sub#{rand(10000)}@example.com"
    }
  end

  let(:variables) do
    {
      input: {
        subsidiaryInput: subsidiary_attributes
      }
    }
  end

  describe 'createSubsidiary' do
    let(:graphql_path) { '/ordenapp/graphql' }

    context 'when user is admin' do
      it 'creates a new subsidiary' do
        post graphql_path, 
             params: { query: mutation, variables: variables },
             headers: { 'Authorization' => "Bearer #{admin_token}" }
        
        json = JSON.parse(response.body)
        
        expect(json['errors']).to be_nil
        data = json['data']['createSubsidiary']
        expect(data['errors']).to be_empty
        expect(data['subsidiary']['name']).to eq('New Subsidiary')
        expect(Subsidiary.count).to be >= 1
      end
    end

    context 'when user is not admin' do
      it 'returns an unauthorized error' do
        post graphql_path, 
             params: { query: mutation, variables: variables },
             headers: { 'Authorization' => "Bearer #{regular_token}" }
        
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
        expect(json['errors'].first['message']).to eq('Unauthorized for the action.')
      end
    end

    context 'when user is not signed in' do
      it 'returns an empty context error or unauthorized' do
        post graphql_path, params: { query: mutation, variables: variables }
        
        json = JSON.parse(response.body)
        # Without token, current_user_graph returns {}, and mutation checks user.present?
        expect(json['errors']).to be_present
        expect(json['errors'].first['message']).to eq('Unauthorized for the action.')
      end
    end
  end
end
