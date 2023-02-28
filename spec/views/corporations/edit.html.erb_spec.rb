require 'rails_helper'

RSpec.describe "corporations/edit", type: :view do
  before(:each) do
    @corporation = assign(:corporation, Corporation.create!(
      :name => "MyString",
      :phone => "MyString",
      :address => "MyString",
      :email => "MyString",
      :identification => "MyString",
      :corporate_initials => "MyString",
      :status => nil
    ))
  end

  it "renders the edit corporation form" do
    render

    assert_select "form[action=?][method=?]", corporation_path(@corporation), "post" do

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
