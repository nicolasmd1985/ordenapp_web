require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  describe 'associations' do
    it 'has many users' do
      expect(described_class.reflect_on_association(:users).macro).to eq :has_many
    end

    it 'has many orders' do
      expect(described_class.reflect_on_association(:orders).macro).to eq :has_many
    end

    it 'has many things' do
      expect(described_class.reflect_on_association(:things).macro).to eq :has_many
    end

    it 'has many categories' do
      expect(described_class.reflect_on_association(:categories).macro).to eq :has_many
    end

    it 'has many components' do
      expect(described_class.reflect_on_association(:components).macro).to eq :has_many
    end

    it 'has many order_rates' do
      expect(described_class.reflect_on_association(:order_rates).macro).to eq :has_many
    end

    it 'has many tools' do
      expect(described_class.reflect_on_association(:tools).macro).to eq :has_many
    end

    it 'belongs to status' do
      expect(described_class.reflect_on_association(:status).macro).to eq :belongs_to
    end

    it 'belongs to corporation' do
      expect(described_class.reflect_on_association(:corporation).macro).to eq :belongs_to
    end
  end
end
