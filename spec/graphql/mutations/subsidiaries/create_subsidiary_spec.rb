require 'rails_helper'

RSpec.describe Mutations::Subsidiaries::CreateSubsidiary, type: :request do
  describe 'admin user can create a Subsidiary successfully' do
    let(:user) { create(:admin_user) }
    let(:mutation) do
      <<-GRAPHQL
        mutation {
          createSubsidiary(
            input: {
              name: "ABC Company",
              phone: "123-456-7890",
              address: "123 Main St, Anytown, USA",
              email: "info@abccompany.com",
              statusId: 1,
              corporationId: 1
            }
          ) {
            subsidiary {
              id
              name
            }
          }
        }
      GRAPHQL
    end

    it 'returns the created subsidiary details' do
      result = execute(mutation, user: user)
      expect(result.dig('data', 'createSubsidiary', 'subsidiary')).to include(
        id: expect.anything,
        name: 'ABC Company'
      )
    end
  end

  describe 'non-admin user gets an Unauthorized error' do
    let(:user) { create(:user) }
    let(:mutation) do
      <<-GRAPHQL
        mutation {
          createSubsidiary(
            input: {
              name: "XYZ Company",
              phone: "987-654-3210",
              address: "456 Elm St, Anytown, USA",
              email: "info@xyzcompany.com",
              statusId: 1,
              corporationId: 1
            }
          ) {
            subsidiary {
              id
              name
            }
          }
        }
      GRAPHQL
    end

    it 'returns an Unauthorized error' do
      result = execute(mutation, user: user)
      expect(result.dig('errors')).to include(
        message: "Authentication failed"
      )
    end
  end

  describe 'missing required fields return validation errors' do
    let(:user) { create(:admin_user) }
    let(:mutation) do
      <<-GRAPHQL
        mutation {
          createSubsidiary(
            input: {
              phone: "123-456-7890",
              address: "123 Main St, Anytown, USA",
              email: "info@abccompany.com",
              statusId: 1,
              corporationId: 1
            }
          ) {
            subsidiary {
              id
              name
            }
          }
        }
      GRAPHQL
    end

    it 'returns validation errors' do
      result = execute(mutation, user: user)
      expect(result.dig('errors')).to include(
        message: "Name can't be blank"
      )
    end
  end
end