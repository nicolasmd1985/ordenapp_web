require 'rails_helper'

RSpec.describe CookiesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #policy" do
    it "returns http success" do
      get :policy
      expect(response).to have_http_status(:success)
    end
  end

end
