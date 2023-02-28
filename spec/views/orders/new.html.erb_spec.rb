require 'rails_helper'

RSpec.describe "orders/new", type: :view do
  before(:each) do
    assign(:order, Order.new(
      :description => "MyString",
      :address => "MyString",
      :priority => 1,
      :initial_time => "",
      :final_time => "",
      :limit_time => "",
      :sync => false
    ))
  end

  it "renders new order form" do
    render

    assert_select "form[action=?][method=?]", orders_path, "post" do

      assert_select "input[name=?]", "order[description]"

      assert_select "input[name=?]", "order[address]"

      assert_select "input[name=?]", "order[priority]"

      assert_select "input[name=?]", "order[initial_time]"

      assert_select "input[name=?]", "order[final_time]"

      assert_select "input[name=?]", "order[limit_time]"

      assert_select "input[name=?]", "order[sync]"
    end
  end
end
