
# spec/factories/subsidiaries.rb
FactoryBot.define do
  factory :subsidiary do
    name              "Subsidiary Name"
    phone             "555-1234"
    address           "123 Main St"
    email             "subsidiary@example.com"
    status             "Active"
    corporation      { name: "Corporate Corp" }
  end
end
