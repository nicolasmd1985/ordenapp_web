require 'rails_helper'

RSpec.describe "tools/index", type: :view do
  before(:each) do
    assign(:tools, [
      Tool.create!(
        :user => nil,
        :status => nil,
        :description => "Description",
        :code_bar => "Code Bar",
        :daily_use => false
      ),
      Tool.create!(
        :user => nil,
        :status => nil,
        :description => "Description",
        :code_bar => "Code Bar",
        :daily_use => false
      )
    ])
  end

  it "renders a list of tools" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Code Bar".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
