require 'spec_helper'

RSpec.describe Subsidiary, type: :model do
  it { should belong_to(:status) }
  it { should belong_to(:corporation) }

  it { should have_many(:users).dependent(:destroy) }
  it { should have_many(:orders).dependent(:destroy) }
  it { should have_many(:things).dependent(:destroy) }
  it { should have_many(:categories).dependent(:destroy) }
  it { should have_many(:components).dependent(:destroy) }
  it { should have_many(:order_rates).dependent(:destroy) }
  it { should have_many(:tools).dependent(:destroy) }

  it { should validate(:name, presence: true, length: { minimum: 3 }) }

  context 'initials calculation' do
    let(:subidiary) { FactoryGirl.create(:subidiary, name: 'Example Subsidiary') }
    let(:subidiary_two) { FactoryGirl.create(:subidiary, name: 'Example Subsidiary 2') }
    let(:subidiary_one_word) { FactoryGirl.create(:subidiary, name: 'Subsidiary') }

    it { expect(subidiary.initials).to eq('ES') }
    it { expect(subidiary_two.initials).to eq('ES') }
    it { expect(subidiary_one_word.initials).to eq('SS') }
  end

  context 'set_subsidiary_initials' do
    let(:subidiary) { FactoryGirl.create(:subidiary, name: 'Example Subsidiary') }
    it { expect(subidiary.initials).to eq('ES') }
  end

end