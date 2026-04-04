
# spec/models/subsidiary_spec.rb

RSpec.describe Subsidiary, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:status_id) }
  it { should validate_presence_of(:corporation_id) }

  it { should callback(:set_subsidiary_initials).after(:create) }
end