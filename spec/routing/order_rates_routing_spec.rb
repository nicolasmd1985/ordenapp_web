require "rails_helper"

RSpec.describe OrderRatesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/order_rates").to route_to("order_rates#index")
    end

    it "routes to #new" do
      expect(:get => "/order_rates/new").to route_to("order_rates#new")
    end

    it "routes to #show" do
      expect(:get => "/order_rates/1").to route_to("order_rates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/order_rates/1/edit").to route_to("order_rates#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/order_rates").to route_to("order_rates#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/order_rates/1").to route_to("order_rates#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/order_rates/1").to route_to("order_rates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/order_rates/1").to route_to("order_rates#destroy", :id => "1")
    end
  end
end
