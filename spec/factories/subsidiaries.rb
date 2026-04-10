FactoryBot.define do
  factory :subsidiary do
    name { Faker::Lorem.words(3) }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    status { Status.first }
    corporation { Corporation.first }

    initialize_with do |attributes|
      attributes[:name]
    end
  end
end