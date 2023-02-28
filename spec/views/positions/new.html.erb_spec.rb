require 'rails_helper'

RSpec.describe "positions/new", type: :view do
  before(:each) do
    assign(:position, Position.new(
      :user => nil,
      :thing => nil,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders new position form" do
    render

    assert_select "form[action=?][method=?]", positions_path, "post" do

      assert_select "input[name=?]", "position[user_id]"

      assert_select "input[name=?]", "position[thing_id]"

      assert_select "input[name=?]", "position[latitude]"

      assert_select "input[name=?]", "position[longitude]"
    end
  end
end
