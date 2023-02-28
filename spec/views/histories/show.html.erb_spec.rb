require 'rails_helper'

RSpec.describe "histories/show", type: :view do
  before(:each) do
    @history = assign(:history, History.create!(
      :thing => nil,
      :description => "Description",
      :text => "Text"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Text/)
  end
end
