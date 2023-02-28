require 'rails_helper'

RSpec.describe "referrals/new", type: :view do
  before(:each) do
    assign(:referral, Referral.new(
      :comment => "MyText",
      :signature => "MyText",
      :full_name => "MyString",
      :email => "MyString",
      :order => nil
    ))
  end

  it "renders new referral form" do
    render

    assert_select "form[action=?][method=?]", referrals_path, "post" do

      assert_select "textarea[name=?]", "referral[comment]"

      assert_select "textarea[name=?]", "referral[signature]"

      assert_select "input[name=?]", "referral[full_name]"

      assert_select "input[name=?]", "referral[email]"

      assert_select "input[name=?]", "referral[order_id]"
    end
  end
end
