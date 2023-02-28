require 'rails_helper'

RSpec.describe "positions/edit", type: :view do
  before(:each) do
    @position = assign(:position, Position.create!(
      :user => nil,
      :thing => nil,
      :latitude => 1.5,
      :longitude => 1.5
    ))
  end

  it "renders the edit position form" do
    render

    assert_select "form[action=?][method=?]", position_path(@position), "post" do

      assert_select "input[name=?]", "position[user_id]"

      assert_select "input[name=?]", "position[thing_id]"

      assert_select "input[name=?]", "position[latitude]"

      assert_select "input[name=?]", "position[longitude]"
    end
  end
end
