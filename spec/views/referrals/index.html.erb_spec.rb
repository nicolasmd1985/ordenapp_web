require 'rails_helper'

RSpec.describe "referrals/index", type: :view do
  before(:each) do
    assign(:referrals, [
      Referral.create!(
        :comment => "MyText",
        :signature => "MyText",
        :full_name => "Full Name",
        :email => "Email",
        :order => nil
      ),
      Referral.create!(
        :comment => "MyText",
        :signature => "MyText",
        :full_name => "Full Name",
        :email => "Email",
        :order => nil
      )
    ])
  end

  it "renders a list of referrals" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Full Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
