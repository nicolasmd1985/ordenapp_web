
# spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb
require 'rails_helper'

RSpec.describe Subsidiary::CreateSubsidiary, type: :request do
  context "admin user can create a Subsidiary successfully" do
    it "creates a new Subsidiary" do
      post '/graphql', params: { query: Subsidiary::CreateSubsidiary.query }, headers: Subsidiary::CreateSubsidiary.header
      expect(response).to have_http_status(:ok)
    end
  end

  context "non-admin user gets an Unauthorized error" do
    it "returns an Unauthorized error" do
      non_admin_headers = Subsidiary::CreateSubsidiary.header
      non_admin_headers[:user_id] = nil
      post '/graphql', params: { query: Subsidiary::CreateSubsidiary.query }, headers: non_admin_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "missing required fields return validation errors" do
    it "returns validation errors" do
      post '/graphql', params: { query: Subsidiary::CreateSubsidiary.query }, headers: Subsidiary::CreateSubsidiary.header
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
