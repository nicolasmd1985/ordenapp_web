require 'rails_helper'

RSpec.describe "maintenances/show", type: :view do
  before(:each) do
    @maintenance = assign(:maintenance, Maintenance.create!(
      :frecuency => 2,
      :out_thing => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
