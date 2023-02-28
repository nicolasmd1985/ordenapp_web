require 'rails_helper'

RSpec.describe "things/index", type: :view do
  before(:each) do
    assign(:things, [
      Thing.create!(
        :status => nil,
        :order => nil,
        :name => "Name",
        :description => "Description",
        :code_scan => "Code Scan",
        :initial_address => "Initial Address",
        :final_address => "Final Address"
      ),
      Thing.create!(
        :status => nil,
        :order => nil,
        :name => "Name",
        :description => "Description",
        :code_scan => "Code Scan",
        :initial_address => "Initial Address",
        :final_address => "Final Address"
      )
    ])
  end

  it "renders a list of things" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Code Scan".to_s, :count => 2
    assert_select "tr>td", :text => "Initial Address".to_s, :count => 2
    assert_select "tr>td", :text => "Final Address".to_s, :count => 2
  end
end
