require 'rails_helper'

RSpec.describe "order_rates/edit", type: :view do
  before(:each) do
    @order_rate = assign(:order_rate, OrderRate.create!(
      :comments => "MyString"
    ))
  end

  it "renders the edit order_rate form" do
    render

    assert_select "form[action=?][method=?]", order_rate_path(@order_rate), "post" do

      assert_select "input[name=?]", "order_rate[comments]"
    end
  end
end
