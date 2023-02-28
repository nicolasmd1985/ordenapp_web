require 'rails_helper'

RSpec.describe "referrals/edit", type: :view do
  before(:each) do
    @referral = assign(:referral, Referral.create!(
      :comment => "MyText",
      :signature => "MyText",
      :full_name => "MyString",
      :email => "MyString",
      :order => nil
    ))
  end

  it "renders the edit referral form" do
    render

    assert_select "form[action=?][method=?]", referral_path(@referral), "post" do

      assert_select "textarea[name=?]", "referral[comment]"

      assert_select "textarea[name=?]", "referral[signature]"

      assert_select "input[name=?]", "referral[full_name]"

      assert_select "input[name=?]", "referral[email]"

      assert_select "input[name=?]", "referral[order_id]"
    end
  end
end
