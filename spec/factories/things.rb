FactoryBot.define do
  factory :thing do
    status { nil }
    order { nil }
    name { "MyString" }
    description { "MyString" }
    code_scan { "MyString" }
    initial_address { "MyString" }
    final_address { "MyString" }
  end
end
