require 'rails_helper'

RSpec.describe "tools/show", type: :view do
  before(:each) do
    @tool = assign(:tool, Tool.create!(
      :user => nil,
      :status => nil,
      :description => "Description",
      :code_bar => "Code Bar",
      :daily_use => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Code Bar/)
    expect(rendered).to match(/false/)
  end
end
