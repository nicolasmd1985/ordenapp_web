```ruby
# spec/factories/subsidiaries.rb
FactoryBot.define do
  factory :subsidiary do
    name { Faker::Lorem.words.sample(3).join(' ') }
    phone { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    status { create(:status, name: 'active') }
    corporation { create(:corporation, name: 'Example Corp') }
  end
end
```