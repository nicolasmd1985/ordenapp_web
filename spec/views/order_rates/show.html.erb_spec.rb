require 'rails_helper'

RSpec.describe "order_rates/show", type: :view do
  before(:each) do
    @order_rate = assign(:order_rate, OrderRate.create!(
      :comments => "Comments"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Comments/)
  end
end
