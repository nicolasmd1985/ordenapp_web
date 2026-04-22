FactoryBot.define do
  factory :user do
    document_number { "24524#{rand(1000..9999)}" }
    first_name { "Nicolas" }
    last_name { "Developer" }
    phone_number_1 { "1234567890" }
    email { "user_#{rand(10000)}@example.com" }
    password { "Password123!" }
    role { :admin }
    association :corporation
    association :status
  end
end
