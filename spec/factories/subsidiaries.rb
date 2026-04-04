# spec/factories/subsidiaries.rb

FactoryBot.define do
  factory :subsidiary do
    name { |n| n.underscore.dasherize }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    status { Status.find_or_create_by(name: 'Active') }
    corporation { Corporation.find_or_create_by(name: 'Example Corporation') }
  end
end