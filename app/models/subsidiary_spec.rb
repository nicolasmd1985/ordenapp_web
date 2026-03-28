```rake
def create_subsidiary_validate_user
  subsidiary = FactoryGirl.create(:subsidiary)
  subsidiary.name = FactoryGirl.build(:corp_product)
  subsidiary.save!
  subsidiary
end


it 'associates users' do
  subsidiary = create_subsidiary_validate_user
  expect(subsidiary.users).to be_present
end


it 'associates order' do
  subsidiary = create_subsidiary_validate_user
  order = FactoryGirl.create(:order_product, :subsidiary_id => subsidiary.id)
  subsidiary.order.add_suborder(order)
  expect(subsidiary.order_suborders).to be_present
end
end



it 'associates categories' do
  subsidiary = create_subsidiary_validate_user
  category = FactoryGirl.build(:category, :subsidiary_id => subsidiary.id)
  subsidiary.categories << category
  expect(subsidiary.categories).to be_present
end



def subsidiary_name(subsidiary_name)
  subsidiary_name.gsub(/ /, '').upcase
end
  end```