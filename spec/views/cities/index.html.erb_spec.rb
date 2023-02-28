require 'rails_helper'

RSpec.describe "cities/index", type: :view do
  before(:each) do
    assign(:cities, [
      City.create!(
        :country => nil,
        :name => ""
      ),
      City.create!(
        :country => nil,
        :name => ""
      )
    ])
  end

  it "renders a list of cities" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
