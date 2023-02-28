require 'rails_helper'

RSpec.describe "corporations/new", type: :view do
  before(:each) do
    assign(:corporation, Corporation.new(
      :name => "MyString",
      :phone => "MyString",
      :address => "MyString",
      :email => "MyString",
      :identification => "MyString",
      :corporate_initials => "MyString",
      :status => nil
    ))
  end

  it "renders new corporation form" do
    render

    assert_select "form[action=?][method=?]", corporations_path, "post" do

      assert_select "input[name=?]", "corporation[name]"

      assert_select "input[name=?]", "corporation[phone]"

      assert_select "input[name=?]", "corporation[address]"

      assert_select "input[name=?]", "corporation[email]"

      assert_select "input[name=?]", "corporation[identification]"

      assert_select "input[name=?]", "corporation[corporate_initials]"

      assert_select "input[name=?]", "corporation[status_id]"
    end
  end
end
