require "rails_helper"

RSpec.describe SubsidiariesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/subsidiaries").to route_to("subsidiaries#index")
    end

    it "routes to #new" do
      expect(:get => "/subsidiaries/new").to route_to("subsidiaries#new")
    end

    it "routes to #show" do
      expect(:get => "/subsidiaries/1").to route_to("subsidiaries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/subsidiaries/1/edit").to route_to("subsidiaries#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/subsidiaries").to route_to("subsidiaries#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/subsidiaries/1").to route_to("subsidiaries#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/subsidiaries/1").to route_to("subsidiaries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subsidiaries/1").to route_to("subsidiaries#destroy", :id => "1")
    end
  end
end
