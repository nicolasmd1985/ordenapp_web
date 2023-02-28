require 'rails_helper'

RSpec.describe "subsidiaries/index", type: :view do
  before(:each) do
    assign(:subsidiaries, [
      Subsidiary.create!(
        :status => nil,
        :name => "Name",
        :phone => "Phone",
        :address => "Address",
        :email => "Email",
        :identification => "Identification"
      ),
      Subsidiary.create!(
        :status => nil,
        :name => "Name",
        :phone => "Phone",
        :address => "Address",
        :email => "Email",
        :identification => "Identification"
      )
    ])
  end

  it "renders a list of subsidiaries" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Identification".to_s, :count => 2
  end
end
