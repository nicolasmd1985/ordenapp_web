```ruby
# spec/models/subsidiary_spec.rb
require 'rails_helper'

RSpec.describe Subsidiary, type: :model do
  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:orders) }
    it { should have_many(:things) }
    it { should have_many(:categories) }
    it { should have_many(:components) }
    it { should have_many(:order_rates) }
    it { should have_many(:tools) }
    it { should belong_to(:status) }
    it { should belong_to(:corporation) }
  end

  describe "callbacks" do
    it "sets subsidiary initials" do
      subsidiary = Subsidiary.new(name: 'Example Subsidiary', corporation: corporation)
      subsidiary.save
      expect(subsidiary.initials).to eq(subsidiary.name.split(' ').first(3).join('').upcase)
    end
  end
end
