require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    assign(:orders, [
      Order.create!(
        :description => "Description",
        :address => "Address",
        :priority => 2,
        :initial_time => "",
        :final_time => "",
        :limit_time => "",
        :sync => false
      ),
      Order.create!(
        :description => "Description",
        :address => "Address",
        :priority => 2,
        :initial_time => "",
        :final_time => "",
        :limit_time => "",
        :sync => false
      )
    ])
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
