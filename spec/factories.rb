FactoryBot.define do
  factory :corporation do
    name { Faker::Company.name }
  end

  factory :status do
    name { Faker::Lorem.words(1).join(' ') }
  end
end