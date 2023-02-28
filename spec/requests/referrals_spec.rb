require 'rails_helper'

RSpec.describe "Referrals", type: :request do
  describe "GET /referrals" do
    it "works! (now write some real specs)" do
      get referrals_path
      expect(response).to have_http_status(200)
    end
  end
end
