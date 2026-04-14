FactoryBot.define do

  factory :subsidiary do
    name { Faker::Company.name }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    status { create(:status) }
    corporation { create(:corporation) }
  end
end