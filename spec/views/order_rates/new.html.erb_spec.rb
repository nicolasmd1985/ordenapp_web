require 'rails_helper'

RSpec.describe "order_rates/new", type: :view do
  before(:each) do
    assign(:order_rate, OrderRate.new(
      :comments => "MyString"
    ))
  end

  it "renders new order_rate form" do
    render

    assert_select "form[action=?][method=?]", order_rates_path, "post" do

      assert_select "input[name=?]", "order_rate[comments]"
    end
  end
end
