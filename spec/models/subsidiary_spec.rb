require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  it { should belong_to(:status) }
  it { should belong_to(:corporation) }

  it { should have_many(:users).with_foreign_key(:subsidiary_id) }
  it { should have_many(:orders).with_foreign_key(:subsidiary_id) }
  it { should have_many(:things).with_foreign_key(:subsidiary_id) }
  it { should have_many(:categories).with_foreign_key(:subsidiary_id) }
  it { should have_many(:components).with_foreign_key(:subsidiary_id) }
  it { should have_many(:order_rates).with_foreign_key(:subsidiary_id) }
  it { should have_many(:tools).with_foreign_key(:subsidiary_id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:status_id) }
  it { should validate_presence_of(:corporation_id) }

  context 'callback' do
    it 'sets subsidiary initials' do
      subsidiary = Subsidiary.create(name: 'Subsidiary Test', status_id: 1, corporation_id: 1)
      expect(subsidiary.initials).to eq('STT')
    end
  end
end