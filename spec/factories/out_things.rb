FactoryBot.define do
  factory :out_thing do
    customer_id { 1 }
    thing_id { 1 }
    stock { 1 }
    thing { nil }
    user { "" }
  end
end
