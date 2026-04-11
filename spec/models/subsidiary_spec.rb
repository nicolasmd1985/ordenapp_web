require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  describe 'associations' do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_many(:things).dependent(:destroy) }
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:components).dependent(:destroy) }
    it { should have_many(:order_rates).dependent(:destroy) }
    it { should have_many(:tools).dependent(:destroy) }
    it { should belong_to(:status) }
    it { should belong_to(:corporation) }
  end

  describe 'callback set_subsidiary_initials' do
    it 'sets initials correctly based on name length' do
      # 3+ words
      subsidiary = create(:subsidiary, name: 'ABC Company')
      expect(subsidiary.initials).to eq('ABC')

      # 2 words
      subsidiary = create(:subsidiary, name: 'XY Company')
      expect(subsidiary.initials).to eq('XY')

      # 1 word
      subsidiary = create(:subsidiary, name: 'X')
      expect(subsidiary.initials).to eq('XXX')
    end
  end

  describe 'class method subsidiary_name(id)' do
    it 'returns the correct name' do
      subsidiary = create(:subsidiary)
      expect(Subsidiary.subsidiary_name(subsidiary.id)).to eq(subsidiary.name)
    end
  end
end