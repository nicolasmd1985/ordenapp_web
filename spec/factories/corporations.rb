FactoryBot.define do
  factory :corporation do
    name { "MyString" }
    phone { "MyString" }
    address { "MyString" }
    email { "MyString" }
    identification { "ID#{rand(1000..9999)}" }
    corporate_initials { "COR" }
    association :status
  end
end
