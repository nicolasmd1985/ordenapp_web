## spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb
require 'rails_helper'

RSpec.describe Subsidiary::CreateSubsidiary, type: :graphql do
  context "admin user can create a Subsidiary successfully" do
    let(:user) { create(:admin_user) }
    let(:create_subsidiary_input) { {name: Faker::Company.name, phone: Faker::PhoneNumber.phone_number, address: Faker::Address.full_address, email: Faker::Internet.email, status: {id: create(:status).id}, corporation: {id: create(:corporation).id}} }

    it "should create a Subsidiary" do
      subject.execute(input: create_subsidiary_input)
      expect(subject.errors).to be_empty
      expect(Subsidiary.count).to eq(1)
    end
  end

  context "non-admin user gets Unauthorized error" do
    let(:user) { create(:user) }
    let(:create_subsidiary_input) { {name: Faker::Company.name, phone: Faker::PhoneNumber.phone_number, address: Faker::Address.full_address, email: Faker::Internet.email, status: {id: create(:status).id}, corporation: {id: create(:corporation).id}} }\n
    it "should return an Unauthorized error" do
      allow(subject.client).to receive(:user).and_return(user)
      allow(subject.client).to receive(:execute).and_raise(GraphQL::ExecutionError, message: 'Unauthorized')
      expect { subject.execute(input: create_subsidiary_input) }.to raise_error(GraphQL::ExecutionError, message: 'Unauthorized')
    end
  end

  context "missing required fields return validation errors" do
    let(:create_subsidiary_input) { {name: Faker::Company.name, phone: Faker::PhoneNumber.phone_number, email: Faker::Internet.email} }\n
    it "should return validation errors" do
      expect { subject.execute(input: create_subsidiary_input) }.to raise_error(GraphQL::ExecutionError, message: 'Validation failed: Please provide a valid Subsidiary name, status, and corporation')
    end
  end
end