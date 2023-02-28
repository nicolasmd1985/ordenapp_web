require 'rails_helper'

RSpec.describe "referrals/show", type: :view do
  before(:each) do
    @referral = assign(:referral, Referral.create!(
      :comment => "MyText",
      :signature => "MyText",
      :full_name => "Full Name",
      :email => "Email",
      :order => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Full Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(//)
  end
end
