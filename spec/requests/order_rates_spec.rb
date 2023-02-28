require 'rails_helper'

RSpec.describe "OrderRates", type: :request do
  describe "GET /order_rates" do
    it "works! (now write some real specs)" do
      get order_rates_path
      expect(response).to have_http_status(200)
    end
  end
end
