require "rails_helper"

RSpec.describe ThingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/things").to route_to("things#index")
    end

    it "routes to #new" do
      expect(:get => "/things/new").to route_to("things#new")
    end

    it "routes to #show" do
      expect(:get => "/things/1").to route_to("things#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/things/1/edit").to route_to("things#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/things").to route_to("things#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/things/1").to route_to("things#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/things/1").to route_to("things#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/things/1").to route_to("things#destroy", :id => "1")
    end
  end
end
