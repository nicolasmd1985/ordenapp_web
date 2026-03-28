```ruby
given(:factory) do |product|
  FactoryGirl.build(:corp_product, :name => { 'product1_name' => 'Product 1' })
end```