require 'rails_helper'

RSpec.describe "histories/index", type: :view do
  before(:each) do
    assign(:histories, [
      History.create!(
        :thing => nil,
        :description => "Description",
        :text => "Text"
      ),
      History.create!(
        :thing => nil,
        :description => "Description",
        :text => "Text"
      )
    ])
  end

  it "renders a list of histories" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
  end
end
