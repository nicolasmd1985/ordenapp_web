require 'rails_helper'

RSpec.describe "tools/edit", type: :view do
  before(:each) do
    @tool = assign(:tool, Tool.create!(
      :user => nil,
      :status => nil,
      :description => "MyString",
      :code_bar => "MyString",
      :daily_use => false
    ))
  end

  it "renders the edit tool form" do
    render

    assert_select "form[action=?][method=?]", tool_path(@tool), "post" do

      assert_select "input[name=?]", "tool[user_id]"

      assert_select "input[name=?]", "tool[status_id]"

      assert_select "input[name=?]", "tool[description]"

      assert_select "input[name=?]", "tool[code_bar]"

      assert_select "input[name=?]", "tool[daily_use]"
    end
  end
end
