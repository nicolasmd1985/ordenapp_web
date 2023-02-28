require 'rails_helper'

RSpec.describe "corporations/index", type: :view do
  before(:each) do
    assign(:corporations, [
      Corporation.create!(
        :name => "Name",
        :phone => "Phone",
        :address => "Address",
        :email => "Email",
        :identification => "Identification",
        :corporate_initials => "Corporate Initials",
        :status => nil
      ),
      Corporation.create!(
        :name => "Name",
        :phone => "Phone",
        :address => "Address",
        :email => "Email",
        :identification => "Identification",
        :corporate_initials => "Corporate Initials",
        :status => nil
      )
    ])
  end

  it "renders a list of corporations" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Identification".to_s, :count => 2
    assert_select "tr>td", :text => "Corporate Initials".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
