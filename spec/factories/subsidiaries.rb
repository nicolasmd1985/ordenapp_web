FactoryBot.define do
  factory :subidiary do
    name { Faker::Commerce.product_name }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
    status { build(:status) }
    corporation { build(:corporation) }
  end

  factory :status do
    name { Faker::Company.name }
  end

  factory :corporation do
    name { Faker::Company.name }
  end

  factory :order do
    subidiary { build(:subidiary) }
    order_rate { build(:order_rate) }
  end

  factory :order_rate do
    order { build(:order) }
    rate { Faker::Number.number(digits: 2) }
  end

  factory :thing do
    subidiary { build(:subidiary) }
    name { Faker::Commerce.product_name }
    quantity { Faker::Number.number(digits: 2) }
  end

  factory :category do
    subidiary { build(:subidiary) }
    name { Faker::Commerce.department }
  end

  factory :order_rate do
    order { build(:order) }
    rate { Faker::Number.number(digits: 2) }
  end

  factory :tool do
    subidiary { build(:subidiary) }
    name { Faker::Commerce.product_name }
  end
end