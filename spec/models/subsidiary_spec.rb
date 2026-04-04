## spec/models/subsidiary_spec.rb
require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  context "associations" do
    it { is_expected.to have_many(:users).with_foreign_key(:subsidary_id) }
    it { is_expected.to have_many(:orders).with_foreign_key(:subsidary_id) }
    it { is_expected.to have_many(:things).with_foreign_key(:subsidary_id) }
    it { is_expected.to have_many(:categories).with_foreign_key(:subsidary_id) }
    it { is_expected.to have_many(:components).with_foreign_key(:subsidary_id) }
    it { is_expected.to have_many(:order_rates).with_foreign_key(:subsidary_id) }
    it { is_expected.to have_many(:tools).with_foreign_key(:subsidary_id) }
    it { is_expected.to belong_to(:status).with_foreign_key(:subsidary_status_id) }
    it { is_expected.to belong_to(:corporation).with_foreign_key(:subsidary_corporation_id) }
  }

  context "callbacks" do
    it "set_subsidiary_initials" do
      subject.set_subsidiary_initials
      expect(subject.initials).to eq(subject.name[0..2].upcase)
    end
  end
end