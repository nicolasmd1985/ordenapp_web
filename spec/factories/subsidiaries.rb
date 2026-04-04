
# spec/factories/subsidiaries.rb

FactoryBot.define do
  factory :subsidiary do
    name { Faker::Company.name }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    status { create(:status, name: 'Active') }
    corporation { create(:corporation, name: 'Example Corp') }
  end
end

# spec/factories/statuses.rb

FactoryBot.define do
  factory :status do
    name { Faker::Company.name }
  end
end

# spec/factories/corporations.rb

FactoryBot.define do
  factory :corporation do
    name { Faker::Company.name }
  end
end
