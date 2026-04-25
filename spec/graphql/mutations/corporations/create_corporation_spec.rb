require 'rails_helper'

RSpec.describe Mutations::CreateCorporation, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_corporation_data) do
    {
      input: {
        subsidiaryInput: {
          name: 'New Corp',
          identification: '67890',
          initials: 'NC',
          statusId: 100
        }
      }
    }
  end
  let(:invalid_corporation_data) do
    {
      input: {
        subsidiaryInput: {
          name: 'Invalid Corp',
          identification: 'invalid',
          initials: 'IC',
          statusId: 100
        }
      }
    }
  end

  before do
    sign_in user
  end

  describe 'Success' do
    it 'creates a new corporation' do
      expect do
        post '/ordenapp/graphql', params: { query: GraphQLMutation.create_corporation(valid_corporation_data) }
      end.to change(Corporation, :count).by(1)
    end
  end

  describe 'Validation' do
    it 'requires valid inputs' do
      expect do
        post '/ordenapp/graphql', params: { query: GraphQLMutation.create_corporation(invalid_corporation_data) }
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
end