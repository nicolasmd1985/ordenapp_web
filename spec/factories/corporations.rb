FactoryBot.define do
  factory :corporation do
    name { 'Test Corp' }
    identification { '12345' }
    initials { 'TC' }
    status { FactoryBot.create(:status) }
  end
end