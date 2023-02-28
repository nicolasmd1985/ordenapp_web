require 'rails_helper'

RSpec.describe "maintenances/index", type: :view do
  before(:each) do
    assign(:maintenances, [
      Maintenance.create!(
        :frecuency => 2,
        :out_thing => nil
      ),
      Maintenance.create!(
        :frecuency => 2,
        :out_thing => nil
      )
    ])
  end

  it "renders a list of maintenances" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
