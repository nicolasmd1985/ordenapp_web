require 'rails_helper'

RSpec.describe "things/edit", type: :view do
  before(:each) do
    @thing = assign(:thing, Thing.create!(
      :status => nil,
      :order => nil,
      :name => "MyString",
      :description => "MyString",
      :code_scan => "MyString",
      :initial_address => "MyString",
      :final_address => "MyString"
    ))
  end

  it "renders the edit thing form" do
    render

    assert_select "form[action=?][method=?]", thing_path(@thing), "post" do

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
