require 'rails_helper'

RSpec.describe "Subsidiaries", type: :request do
  describe "GET /subsidiaries" do
    it "works! (now write some real specs)" do
      get subsidiaries_path
      expect(response).to have_http_status(200)
    end
  end
end
