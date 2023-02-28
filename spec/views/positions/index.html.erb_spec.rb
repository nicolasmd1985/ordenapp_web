require 'rails_helper'

RSpec.describe "positions/index", type: :view do
  before(:each) do
    assign(:positions, [
      Position.create!(
        :user => nil,
        :thing => nil,
        :latitude => 2.5,
        :longitude => 3.5
      ),
      Position.create!(
        :user => nil,
        :thing => nil,
        :latitude => 2.5,
        :longitude => 3.5
      )
    ])
  end

  it "renders a list of positions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
  end
end
