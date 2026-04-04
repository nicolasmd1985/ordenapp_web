# spec/models/subsidiary_spec.rb

require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  let(:subsidiary) { FactoryBot.create(:subsidiary) }
  let(:user) { FactoryBot.create(:user) }

  it 'has correct associations' do
    expect(subsidiary).to have_many(:users)
    expect(subsidiary).to have_many(:orders)
    expect(subsidiary).to have_many(:things)
    expect(subsidiary).to have_many(:categories)
    expect(subsidiary).to have_many(:components)
    expect(subsidiary).to have_many(:order_rates)
    expect(subsidiary).to have_many(:tools)
    expect(subsidiary).to belong_to(:status)
    expect(subsidiary).to belong_to(:corporation)
  end

  it 'sets subsidiary initials correctly' do
    expect(subsidiary.name).to eq('Subsidiary Name')
    expect(subsidiary.subsidiary_initials).to eq('SN')
  end
end