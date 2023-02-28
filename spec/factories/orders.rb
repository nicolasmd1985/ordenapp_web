FactoryBot.define do
  factory :order do
    description { "MyString" }
    address { "MyString" }
    priority { 1 }
    initial_time { "" }
    final_time { "" }
    limit_time { "" }
    sync { false }
  end
end
