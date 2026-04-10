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
    it { should belong_to(:status).dependent(:destroy) }
    it { should belong_to(:corporation).dependent(:destroy) }
  end

  describe '#set_subsidiary_initials' do
    it 'sets initials correctly' do
      subsidiary = Subsidiary.new(name: 'Subsidiary Inc.', status: Status.first, corporation: Corporation.first)
      subsidiary.set_subsidiary_initials
      expect(subsidiary.initials).to eq('SI')
    end

    it 'sets initials correctly for 2-word name' do
      subsidiary = Subsidiary.new(name: 'ABC Corp.', status: Status.first, corporation: Corporation.first)
      subsidiary.set_subsidiary_initials
      expect(subsidiary.initials).to eq('AC')
    end

    it 'sets initials correctly for 1-word name' do
      subsidiary = Subsidiary.new(name: 'XYZ', status: Status.first, corporation: Corporation.first)
      subsidiary.set_subsidiary_initials
      expect(subsidiary.initials).to eq('XYZ')
    end
  end
end