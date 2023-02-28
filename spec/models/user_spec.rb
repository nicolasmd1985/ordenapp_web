require 'rails_helper'

describe User, :type => :model do
  @user = FactoryBot.create(:user)
  context "valid Factory" do
    it "has a valid factory" do
      expect(@user).to be_valid
    end
  end

  context "validations" do
    before { create(:user) }

    context "presence" do
      it { should validate_presence_of :first_name }
      it { should validate_presence_of :last_name }
      it { should validate_presence_of :email }
      it { should validate_presence_of :encrypted_password }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of :email }
      it { should validate_uniqueness_of :username }
    end
  end
end