require 'rails_helper'

RSpec.describe Corporation, type: :model do
  before(:each) do
    @status = FactoryBot.create(:status)
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      @corporation = FactoryBot.create(:corporation, name: 'Test Corp', identification: '12345', initials: 'TC')
      expect(@corporation).to be_valid
    end

    it 'is invalid without a name' do
      @corporation = FactoryBot.build(:corporation, name: nil)
      expect(@corporation).not_to be_valid
    end

    it 'is invalid without an identification' do
      @corporation = FactoryBot.build(:corporation, identification: nil)
      expect(@corporation).not_to be_valid
    end

    it 'is invalid without initials' do
      @corporation = FactoryBot.build(:corporation, initials: nil)
      expect(@corporation).not_to be_valid
    end
  end

  describe 'Associations' do
    it 'belongs to a status' do
      @corporation = FactoryBot.create(:corporation)
      expect(@corporation.status).to be_present
    end

    it 'has many subsidiaries' do
      @corporation = FactoryBot.create(:corporation)
      subsidiary = FactoryBot.create(:subsidiary, corporation: @corporation)
      expect(@corporation.subsidiaries).to include(subsidiary)
    end
  end

  describe 'Factory' do
    it 'creates a valid corporation' do
      corporation = FactoryBot.create(:corporation)
      expect(corporation).to be_valid
    end
  end
end