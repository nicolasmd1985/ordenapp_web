require 'rails_helper'

RSpec.describe "things/show", type: :view do
  before(:each) do
    @thing = assign(:thing, Thing.create!(
      :status => nil,
      :order => nil,
      :name => "Name",
      :description => "Description",
      :code_scan => "Code Scan",
      :initial_address => "Initial Address",
      :final_address => "Final Address"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Code Scan/)
    expect(rendered).to match(/Initial Address/)
    expect(rendered).to match(/Final Address/)
  end
end
