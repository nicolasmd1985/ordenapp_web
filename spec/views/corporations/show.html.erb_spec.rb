require 'rails_helper'

RSpec.describe "corporations/show", type: :view do
  before(:each) do
    @corporation = assign(:corporation, Corporation.create!(
      :name => "Name",
      :phone => "Phone",
      :address => "Address",
      :email => "Email",
      :identification => "Identification",
      :corporate_initials => "Corporate Initials",
      :status => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Identification/)
    expect(rendered).to match(/Corporate Initials/)
    expect(rendered).to match(//)
  end
end
