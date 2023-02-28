require 'rails_helper'

RSpec.describe "maintenances/new", type: :view do
  before(:each) do
    assign(:maintenance, Maintenance.new(
      :frecuency => 1,
      :out_thing => nil
    ))
  end

  it "renders new maintenance form" do
    render

    assert_select "form[action=?][method=?]", maintenances_path, "post" do

      assert_select "input[name=?]", "maintenance[frecuency]"

      assert_select "input[name=?]", "maintenance[out_thing_id]"
    end
  end
end
