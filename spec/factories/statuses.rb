# spec/factories/statuses.rb

FactoryBot.define do
  factory :status do
    name { Faker::Company.status }
  end
end