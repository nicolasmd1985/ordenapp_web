FactoryBot.define do
  factory :tool do
    user { nil }
    status { nil }
    description { "MyString" }
    code_bar { "MyString" }
    daily_use { false }
  end
end
