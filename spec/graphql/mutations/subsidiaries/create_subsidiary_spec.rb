```ruby
# spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb
require "rails_helper"

RSpec.describe SubsidiaryMutation, type: :graphql do
  let(:headers) { { "HTTP_AUTHORIZATION" => "Bearer #{AdminUser.create!&.access_token}" } }
  let(:mutation) do
    "mutation{
      subsidiaryCreate(input: {name: "Subsidiary1", phone: "555-555-5555", address: "123 Main St", email: "subsidiary1@example.com", status: 1, corporation: 1}){
        name
        phone
        address
        email
        status
        corporation
      }
    }"
  end

  context "when an admin user creates a subsidiary" do
    it "returns the correct details" do
      result = execute_graphql(mutation, headers)
      expect(result.dig(:data, :subsidiaryCreate)).to eq({
        name: "Subsidiary1",
        phone: "555-555-5555",
        address: "123 Main St",
        email: "subsidiary1@example.com",
        status: 1,
        corporation: 1
      })
    end
  end

  context "when a non-admin user tries to create a subsidiary" do
    let(:headers) { { "HTTP_AUTHORIZATION" => "Bearer #{NonAdminUser.create!&.access_token}" } }

    it "returns an unauthorized error" do
      result = execute_graphql(mutation, headers)
      expect(result).to include(
        errors: {
          subsidiaryCreate: [
            { message: "You are not allowed to create subsidiaries", code: "Unauthorized" }
          ]
        }
      )
    end
  end

  context "when a subsidiary has missing required fields" do
    let(:headers) { { "HTTP_AUTHORIZATION" => "Bearer #{AdminUser.create!&.access_token}" } }
    let(:mutation) do
      "mutation{
        subsidiaryCreate(input: {name: "Subsidiary", status: 1, corporation: 1}){
          name
          phone
          address
          email
          status
          corporation
        }
      }"
    end

    it "returns validation errors" do
      result = execute_graphql(mutation, headers)
      expect(result.dig(:errors)).to eq(
        subsidiaryCreate: [
          { message: "Subsidiary phone, address, or email can't be blank", code: "Validation" }
        ]
      )
    end
  end
end
