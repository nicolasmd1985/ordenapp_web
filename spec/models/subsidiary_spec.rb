
# spec/models/subsidiary_spec.rb
require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  context "associations" do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:orders) }
    it { is_expected.to have_many(:things) }
    it { is_expected.to have_many(:categories) }
    it { is_expected.to have_many(:components) }
    it { is_expected.to have_many(:order_rates) }
    it { is_expected.to have_many(:tools) }
    it { is_expected.to belong_to(:status) }
    it { is_expected.to belong_to(:corporation) }
  end

  context "callbacks" do
    it { is_expected.to set_subsidary_initials }
  end

  it "has a correct name" do
    expect(Subsidiary.subsidiary_name(1)).to eq("Subsidiary Name")
  end

  it "sets initials correctly based on name length" do
    expect(Subsidiary.subsidiary_initials("Subsidiary Name")).to eq("SN")
    expect(Subsidiary.subsidiary_initials("Corporate Corp"))
    expect(Subsidiary.subsidiary_initials("Simple Sub"))
  end
end
