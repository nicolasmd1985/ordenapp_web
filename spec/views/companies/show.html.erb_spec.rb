require 'rails_helper'

RSpec.describe "subsidiaries/show", type: :view do
  before(:each) do
    @subsidiary = assign(:subsidiary, Subsidiary.create!(
      :status => nil,
      :name => "Name",
      :phone => "Phone",
      :address => "Address",
      :email => "Email",
      :identification => "Identification"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Identification/)
  end
end
