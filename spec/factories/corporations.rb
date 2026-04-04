FactoryBot.define do
  factory :corporation do
    name { Faker::Company.name }
  end
end