FactoryBot.define do
  factory :subsidiary do
    name { "Subsidiary #{rand(1000)}" }
    phone { "1234567890" }
    address { "Calle Falsa 123" }
    email { "subsidiary_#{rand(1000)}@example.com" }
    identification { "ID#{rand(1000..9999)}" }
    association :status
    association :corporation
  end
end
