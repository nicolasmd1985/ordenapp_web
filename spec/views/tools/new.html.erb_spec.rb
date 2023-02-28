require 'rails_helper'

RSpec.describe "tools/new", type: :view do
  before(:each) do
    assign(:tool, Tool.new(
      :user => nil,
      :status => nil,
      :description => "MyString",
      :code_bar => "MyString",
      :daily_use => false
    ))
  end

  it "renders new tool form" do
    render

    assert_select "form[action=?][method=?]", tools_path, "post" do

      assert_select "input[name=?]", "tool[user_id]"

      assert_select "input[name=?]", "tool[status_id]"

      assert_select "input[name=?]", "tool[description]"

      assert_select "input[name=?]", "tool[code_bar]"

      assert_select "input[name=?]", "tool[daily_use]"
    end
  end
end
