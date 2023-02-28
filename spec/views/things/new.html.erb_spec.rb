require 'rails_helper'

RSpec.describe "things/new", type: :view do
  before(:each) do
    assign(:thing, Thing.new(
      :status => nil,
      :order => nil,
      :name => "MyString",
      :description => "MyString",
      :code_scan => "MyString",
      :initial_address => "MyString",
      :final_address => "MyString"
    ))
  end

  it "renders new thing form" do
    render

    assert_select "form[action=?][method=?]", things_path, "post" do

      assert_select "input[name=?]", "thing[status_id]"

      assert_select "input[name=?]", "thing[order_id]"

      assert_select "input[name=?]", "thing[name]"

      assert_select "input[name=?]", "thing[description]"

      assert_select "input[name=?]", "thing[code_scan]"

      assert_select "input[name=?]", "thing[initial_address]"

      assert_select "input[name=?]", "thing[final_address]"
    end
  end
end
