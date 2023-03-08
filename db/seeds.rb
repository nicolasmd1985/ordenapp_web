def starting_seed
  puts '==================================='
  puts 'Starting seeding'
  puts '==================================='
  # status seeder
  puts 'Starting status seeding...'
  puts '==================================='

  # subsidiary 100
  subsidiary_ids = [100 ,101]
  subsidiary_status =['Active', 'Inactive']
  subsidiary_status.size.times { |i| Status.create(id: subsidiary_ids[i], type_status: 'subsidiary_status', description: subsidiary_status[i]) }

  # user 200
  user_ids = [200, 201, 202, 203, 204, 205, 206]
  user_status = ['Active', 'Inactive', 'Available', 'Busy', 'On the Way', 'Out service']
  user_status.size.times { |i| Status.create(id: user_ids[i], type_status: 'user_status', description: user_status[i]) }

  # thing 300
  thing_ids = [300, 301, 302, 303, 304, 305, 306, 307, 308]
  thing_status = ['Active', 'Inactive', 'Stock', 'Installed', 'Installing', 'Replacement', 'On the Way', 'Corrective Maintenance', 'Preventive Maintenance']
  thing_status.size.times { |i| Status.create(id: thing_ids[i], type_status: 'thing_status', description: thing_status[i]) }

  # tools 400
  tools_ids = [400, 401, 402, 404]
  tools_status = ['Assigned', 'Stock', 'Replacement', 'Lost']
  tools_status.size.times { |i| Status.create(id: tools_ids[i], type_status: 'tools_status', description: tools_status[i]) }

  # order 500
  order_ids = [500, 501, 502, 503, 504, 505]
  order_status = ['Request', 'Assigned', 'In Progress', 'Rejected', 'Done', 'Pre request']
  order_status.size.times { |i| Status.create(id: order_ids[i], type_status: 'order_status', description: order_status[i]) }



  puts 'Status seeding finished.'
  puts '==================================='

  # Country seeder
  countries = ['Colombia']
  country_codes = ['col']
  puts 'Starting country seeding...'
  puts '==================================='
  countries.size.times { |i| Country.create(name: countries[i], country_code: country_codes[i]) }
  puts 'Country seeding finished.'
  puts '==================================='

  # City seeder
  cities = ['Bogotá', 'Medellin', 'Cali', 'Barranquilla', 'Cartagena de Indias', 'Soledad', 'Cúcuta', 'Soacha', 'Ibagué', 'Bucaramanga', 'Villavicencia', 'Santa Marta', 'Bello', 'Valledupar', 'Pereira', 'Buenaventura', 'Pasto', 'Manizales', 'Monteria', 'Neiva']
  puts 'Starting city seeding...'
  puts '==================================='
  cities.size.times { |i| City.create(country_id: 1, name: cities[i]) }
  puts 'City seeding finished.'
  puts '==================================='

  # Subsidiary seeder
  puts 'Starting subsidiary seeding...'
  puts '==================================='
  Subsidiary.create(status_id: 100, name: 'Cencosud', phone: '123123123', address: 'cra 2134', email: 'cencosud@gmail.com', identification: '123123123')
  puts 'Subsidiary seeding finished.'
  puts '==================================='

  # User seeder
  puts 'Starting user seeding...'
  puts '==================================='
  # supervisor
  # User.create(identification: '123456789', first_name: 'Alex', last_name: 'Tintor', phone_number_1: '3207894562', email: 'alextintor@gmail.com', encrypted_password: 'Secret123', password: 'Secret123', role: 1, city_id: 1, subsidiary_id: 1, active: true, status_id: 202)
  # tecnic
  # User.create(identification: '987654321', first_name: 'Todd', last_name: 'Howard', phone_number_1: '3216589715', email: 'roberto@gmail.com', encrypted_password: 'Secret123', password: 'Secret123', role: 0, city_id: 1, subsidiary_id: 1, active: true, status_id: 202)
  # customer
  # User.create(identification: '12323324543', first_name: 'Andres', last_name: 'Roa', phone_number_1: '3057458895', email: 'andfb18@gmail.com', encrypted_password: 'dipzo123', password: 'dipzo123', role: 2, city_id: 1, subsidiary_id: 1, active: true, status_id: 202)
  puts 'User seeding finished.'
  puts '==================================='

  puts 'Seeding finished.'
  puts '==================================='
end

def data_fake
  # create user tecnic
  current_user = User.find(1)
  10.times do
    user(0,current_user)
    user(2,current_user)
  end

  tecnics = User.where(subsidiary_id: current_user.subsidiary_id, role: 0).map(&:id)
  customers = User.where(subsidiary_id: current_user.subsidiary_id, role: 2).map(&:id)
  1000.times do
    order(current_user, customers, tecnics)
  end
  # 100.times do
  #   Thing.create(identification: , :first_name, :last_name, :email, :phone_number_1, :subsidiary_id, :role, :status_id, :active, :city_id)
  # end
end

def user(role, current_user)
  User.create(
    identification: Faker::IDNumber.valid,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number_1: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email,
    encrypted_password: current_user.subsidiary.password,
    password: current_user.subsidiary.password,
    role: role,
    city_id: 1,
    subsidiary_id: current_user.subsidiary_id,
    active: true,
    status_id: 200)
end

def order(current_user, customers, tecnics)
  order = Order.create(
    description: Faker::Lorem.paragraph,
    address: Faker::Address.full_address,
    sync: true,
    supervisor_id: current_user.id.to_i,
    customer_id: customers.sample,
    tecnic_id: tecnics.sample,
    status_id: 504,
    install_date: Time.now,
    install_time: Time.now + rand(2+20).day,
    city_id: 1)
  referral(order)

end


def referral(order)
  Referral.create(
    comment: Faker::Lorem.paragraph,
    signature: SecureRandom.hex(13),
    full_name: Faker::Name.first_name,
    final_time: Time.now + 1.day,
    order_id: order.id
  )
  10.times do
    thing(order)
  end
end


def thing(order)
  thing_ids = [300, 301, 302, 303, 304, 305, 306, 307, 308]
  Thing.create(
    status_id: thing_ids.sample,
    order_id: order.id,
    name: Faker::Vehicle.standard_specs[0],
    description: Faker::Vehicle.make_and_model,
    code_scan: Faker::Vehicle.vin,
    initial_address: order.address,
    final_address: Faker::Address.full_address
  )

end


def create_categories
  # subsidiary 100
  categories_id = [101 ,102, 103]
  categories_name = ['install', 'maintenance', 'repair']
  categories_name.size.times { |i| Category.create(id: categories_id[i], name: categories_name[i]) }
  puts "****************************************ok"
end

def assign_subsidiaries
  puts '==================================='
  puts 'Find orders without subsidiary relations'
  Order.where(subsidiary_id: nil).each{|order| order.update_attribute(:subsidiary_id, User.find(order.supervisor_id).subsidiary.id)}
  puts 'subsidiary_id assigned to orders'
  puts 'Start generate slug to old records'
  Order.create_slugs
  puts 'slug generating finished'
end

def assign_status_to_things
  puts '==================================='
  puts 'Find things without subsidiary relations'
  Thing.where(subsidiary_id: nil).each{|thing| thing.update_attributes(subsidiary_id: 1)}
  puts 'subsidiary_id assigned to things'
  puts 'Start generate slug to old records'
  Thing.create_slugs
  puts 'slug generating finished'
end

def category_to_things
  puts '==================================='
  puts 'Generate the default category'
  @category = Category.new
  @category.name = "Dispositivo"
  @category.created_at = "2020-07-28 19:59:55"
  @category.updated_at = "2020-07-28 20:01:30"
  @category.category_type = "Thing"
  @category.save(validate: false)
  puts 'Category generated'
  category = Category.find_by(name: "Dispositivo")
  puts 'Start to assign category_id to the old things'
  things = Thing.where(category_id: nil)
  things.each do |thing|
    thing.category_id = category.id
    thing.save(validate: false)
    puts "Thing #{thing.id} category_id updated to: #{thing.category_id}"
  end
  puts 'Assingment done'
  puts '==================================='
end

def set_subsidiary_initials(subsidiary)
  @subsidiary_initials = ''
  initials = subsidiary.name.split(' ')

  if initials.size >= 3
    3.times do |x|
      @subsidiary_initials += initials[x][0].upcase
    end
    return @subsidiary_initials
  elsif initials.size == 2
    2.times do |x|
      @subsidiary_initials += initials[x][0].upcase
    end
    return @subsidiary_initials
  else
    @subsidiary_initials = subsidiary.name[0..2].upcase
    return @subsidiary_initials
  end
end

def set_initials_to_all_subsidiaries
  puts '==================================='
  subsidiaries = Subsidiary.where(subsidiary_initials: nil)
  puts 'Start to set initials to subsidiaries'
  subsidiaries.each do |subsidiary|
    subsidiary.subsidiary_initials = set_subsidiary_initials(subsidiary)
    subsidiary.save(validate: false)
    puts "Subsidiary #{subsidiary.name} updated."
  end
  puts 'Assingment done'
  puts '==================================='
end

def set_internal_id_to_old_things
  puts '==================================='
  things = Thing.where(internal_id: nil)
  puts 'Start to set initials to things'
  things.each do |thing|
    category = thing.category_id ? Category.find(thing.category_id) : Category.find_by(name: "Dispositivo")
    category_initials = category.name[0..2].upcase
    sequence = Thing.where(subsidiary_id: thing.subsidiary_id).where.not(internal_id: nil?).count + 1
    thing.internal_id = "#{category_initials}-#{sequence}"
    puts "Thing #{thing.name} internal_id updated to #{thing.internal_id}"
    thing.save(validate: false)
  end
  puts 'Assingment done'
  puts '==================================='
end

def create_corporation
  puts 'Start corporations seeding...'
  puts '==================================='
  Corporation.create(status_id: 100, name: 'Dipzo', phone: '123123123', address: 'Suba', email: 'dipzo@dipzo.net', identification: '123456789', corporate_initials: 'DIP')
  puts 'Finished corporations seeding...'
  puts '==================================='
  @corporation = Corporation.first
  assign_subsidiaries_to_corporation(@corporation)
  assign_subsidiaries_to_users(@corporation)
end

def assign_subsidiaries_to_corporation(corporation)
  puts '==================================='
  @subsidiaries = Subsidiary.where(corporation_id: nil)
  puts 'Start to set corporation_id to subsidiaries'
  @subsidiaries.each do |subsidiary|
    subsidiary.corporation_id = corporation.id
    subsidiary.save(validate: false)
    puts "Subsidiary #{subsidiary.name} corporation_id updated."
  end
  puts 'Assingment done'
  puts '==================================='
end

def assign_subsidiaries_to_users(corporation)
  puts '==================================='
  @users = User.where(corporation_id: nil)
  puts 'Start to set corporation_id to users'
  @users.each do |user|
    user.corporation_id = corporation.id
    user.save(validate: false)
    puts "User #{user.id} corporation_id updated."
  end
  puts 'Assingment done'
  puts '==================================='
end

def city_id_not_null
  puts '==================================='
  @users = User.where(city_id: nil)
  puts 'Start to set city_id to users'
  @users.each do |user|
    user.city_id = 1
    user.save(validate: false)
    puts "User #{user.id} city_id updated."
  end
  puts 'Assingment done'
  puts '==================================='
end

def admin_for_beta
  puts '==================================='
  puts 'Creating admin user'
  User.create(document_number: '56549854', first_name: 'Admin', last_name: 'Admin', phone_number_1: '3207894562', email: 'admin@dipzo.net', encrypted_password: 'nL8*zJ9#hU2#kT0@', password: 'nL8*zJ9#hU2#kT0@', role: 3, city_id: 1, subsidiary_id: nil, corporation_id: 1, active: true, status_id: 200)
  puts "Admin user created"
  puts '==================================='
end


def code_scan()
  puts '==================================='
  puts 'Update internal_id and code scan to slug for things'
  @things = Thing.all
  @things.each do |thing|
    thing.code_scan = thing.slug
    thing.internal_id = thing.slug
    thing.save(validate: false)
    puts "New code scan: #{thing.code_scan} for thing #{thing.id}"
  end
  puts 'Finished updating'
  puts '==================================='
end

def seed_substatus
  puts '==================================='
  puts 'Starts substatus seeding'


  order_ids = [506, 507, 508, 509, 510, 511, 512]
  order_status = ['Pending', 'Receivable', 'Service center', 'Service evaluation', 'Arrives place', 'Generated manual order', 'No Progress']
  order_status.size.times { |i| Status.create(id: order_ids[i], type_status: 'order_status', description: order_status[i]) }


  substatus_504_ids = [600, 601]
  substatus_504 = ["Warranty", "Service quality"]
  substatus_504.size.times{|i| Substatus.create(id: substatus_504_ids[i], visible: true, description: substatus_504[i], status_id: 504)}

  substatus_506_ids = [620, 621, 622, 623, 624, 625, 626, 627, 628, 629]
  substatus_506 = ["Cancelled", "Absent customer", "Canceled due non-compliance", "Price quote pending", "Pending by budget", "Canceled by customer", "Authorization required", "Wrong data", "Product return", "Waiting customer contact"]
  substatus_506.size.times{|i| Substatus.create(id: substatus_506_ids[i], visible: true, description: substatus_506[i], status_id: 506)}

  substatus_507_ids = [640, 641, 642]
  substatus_507 = ["Prepaid", "Paid", "Warranty"]
  substatus_507.size.times{|i| Substatus.create(id: substatus_507_ids[i], visible: true, description: substatus_507[i], status_id: 507)}

  substatus_508_ids = [660, 661, 662]
  substatus_508 = ["Product return", "Delivered goods", "Transfer to service center"]
  substatus_508.size.times{|i| Substatus.create(id: substatus_508_ids[i], visible: true, description: substatus_508[i], status_id: 508)}
  puts 'Seeding finished'
  puts '==================================='
end

def new_user_statuses
  Status.create(id: 207, type_status: 'user_status', description: "Not Available")
  Status.create(id: 208, type_status: 'user_status', description: "Absence")
end


# new_user_statuses()

# seed_substatus()

# code_scan()

# admin_for_beta()
# city_id_not_null()
# create_corporation()

# set_initials_to_all_subsidiaries()
# category_to_things()
# set_internal_id_to_old_things()

# assign_status_to_things()
# assign_subsidiaries()
# create_categories()
# data_fake()

# starting_seed()
def start
  starting_seed()
  create_categories()
  seed_substatus()
  new_user_statuses()
end

start()