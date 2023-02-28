require 'rails_helper'

RSpec.describe "histories/edit", type: :view do
  before(:each) do
    @history = assign(:history, History.create!(
      :thing => nil,
      :description => "MyString",
      :text => "MyString"
    ))
  end

  it "renders the edit history form" do
    render

    assert_select "form[action=?][method=?]", history_path(@history), "post" do

      assert_select "input[name=?]", "history[thing_id]"

      assert_select "input[name=?]", "history[description]"

      assert_select "input[name=?]", "history[text]"
    end
  end
end
