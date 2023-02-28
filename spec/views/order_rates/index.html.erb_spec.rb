require 'rails_helper'

RSpec.describe "order_rates/index", type: :view do
  before(:each) do
    assign(:order_rates, [
      OrderRate.create!(
        :comments => "Comments"
      ),
      OrderRate.create!(
        :comments => "Comments"
      )
    ])
  end

  it "renders a list of order_rates" do
    render
    assert_select "tr>td", :text => "Comments".to_s, :count => 2
  end
end
