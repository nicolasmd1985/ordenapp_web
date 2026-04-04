```ruby
# spec/models/subsidiary_spec.rb
require "rails_helper"

RSpec.describe Subsidiary, type: :model do
  it { should have_many(:users).dependent(:destroy) }
  it { should have_many(:orders).dependent(:destroy) }
  it { should have_many(:things).dependent(:destroy) }
  it { should have_many(:categories).dependent(:destroy) }
  it { should have_many(:components).dependent(:destroy) }
  it { should have_many(:order_rates).dependent(:destroy) }
  it { should have_many(:tools).dependent(:destroy) }
  it { should have_one(:status).dependent(:destroy) }
  it { should have_one(:corporation).dependent(:destroy) }
  it { should callback(:set_subsidiary_initials).with([:name]) }

  it { should_not allow_value("").for(:name) }
  it { should allow_value("A").for(:name) }
  it { should allow_value("AB").for(:name) }
  it { should allow_value("ABC").for(:name) }
  it { should_not allow_value("ABCD").for(:name) }

  context "when name has 3+ words" do
    it "returns uppercase initials of the first 3 words in name" do
      s = Subsidiary.new(name: "Subsidiary ABCD").set_subsidiary_initials
      expect(s.subsidiary_initials).to eq("SAB")
    end
  end

  context "when name has 2 words" do
    it "returns uppercase initials of the first 2 words in name" do
      s = Subsidiary.new(name: "Subsidiary AB").set_subsidiary_initials
      expect(s.subsidiary_initials).to eq("SA")
    end
  end

  context "when name has 1 word" do
    it "returns uppercase initials of the first 3 characters in name" do
      s = Subsidiary.new(name: "Subsidiary").set_subsidiary_initials
      expect(s.subsidiary_initials).to eq("SUB")
    end
  end

  describe "subsidiary_name method" do
    context "when given an id" do
      let(:subsidiary) { Subsidiary.first }
      it "returns the correct name" do
        expect(subsidiary.subsidiary_name(subsidiary.id)).to eq(subsidiary.name)
      end
    end
  end
end
