class Order < ApplicationRecord
	serialize :things_ids, Array
	acts_as_xlsx :columns => [:internal_id, :customer_id_order, :created_at, :updated_at,
														:description, "city.name",
														"supervisor.first_name", "supervisor.last_name",
														"tecnic.first_name", "tecnic.last_name",
														"customer.first_name", "customer.last_name",
														:address, :status_id, "status.description", :substatus_id,
														"substatus.description", :install_date, :install_time,
														:limit_time, "category.name", :comment,
														"subsidiary.name", :sync, :origin], :i18 => true

	before_save :default_values
	before_create :set_slug
	before_create :set_internal_id

	self.skip_time_zone_conversion_for_attributes = [:install_time, :limit_time]

	validates :description, presence: true
	validates :address, presence: true
	validates :install_date, presence: true, if: -> { self.status_id != 505}
	validates :install_time, presence: true, if: -> { self.status_id != 505}

	belongs_to :supervisor, class_name: 'User', optional: true
	belongs_to :tecnic, class_name: 'User', optional: true
	belongs_to :customer, class_name: 'User', optional:true
	belongs_to :status
	belongs_to :substatus, optional: true
	belongs_to :city
	belongs_to :subsidiary
	belongs_to :category, optional: true
	belongs_to :out_thing, optional: true

	has_one :order_rate, dependent: :delete

	has_many :histories, dependent: :delete_all	
	has_many :comments
	has_many :logs, class_name: "Orders::Log", dependent: :delete_all

	# this method define the many_to_many relationship from orders to things
	def things
		things = self.things_ids
    Thing.where(id: things)
  end

	def out_things
		out_things = self.out_thing_ids
    OutThing.where(id: out_things)
  end
	# method to return the parent order
	def parents
		Order.where(id: self.try(:parent_order)).first
	end

	# method to return children orders
	def childrens
		Order.where(parent_order: self.id)
	end

	def set_slug
		begin
			self.slug = SecureRandom.hex
		end while self.class.exists?(slug: self.slug)
	end

	def to_params
		slug
	end

	def self.create_slugs
   Order.all.each do |order|
    order.set_slug
		order.save!
   end
  end

	def set_internal_id
		subsidiary = Subsidiary.find(self.subsidiary_id)
		if self.status_id == 505
			sequence = Order.where(subsidiary_id: subsidiary.id).where("internal_id LIKE 'TS-%'").count + 1
			self.internal_id = "TS-#{subsidiary.subsidiary_initials}-#{sequence}"
		else
			sequence = Order.where(subsidiary_id: subsidiary.id).count + 1
			self.internal_id = "#{subsidiary.subsidiary_initials}-#{sequence}"
		end
	end

	def set_subsidiary_initials_from_order(subsidiary)
		@subsidiary = subsidiary
    @subsidiary_initials = ''
    initials = @subsidiary.name.split(' ')
    if initials.size >= 3
      3.times do |x|
        @subsidiary_initials += initials[x][0].upcase!
      end
      @subsidiary.update(subsidiary_initials: @subsidiary_initials)
    else
      @subsidiary_initials = @subsidiary.name[0..2].upcase!
			@subsidiary.update(subsidiary_initials: @subsidiary_initials)
    end
		@subsidiary
  end

	def self.order_user(user)
		User.find(user)
	end

	def default_values
		self.sync ||= false # note self.status = 'P' if self.status.nil? might be safer (per @frontendbeauty)
	end

	def self.all_orders(subsidiary)
		supervisors = User.where(subsidiary_id: subsidiary, role: 1).ids
		Order.includes(:tecnic, :customer, :city, :status, :substatus).where(supervisor_id: supervisors)
		.or(Order.includes(:tecnic, :customer, :city, :status, :substatus).where(subsidiary_id: subsidiary)).order(created_at: :desc).limit(500)
	end

	def self.orders_pendig(supervisor)
		user = User.find(supervisor)
		Order.includes(:tecnic, :customer, :city, :status, :substatus).where({status_id: [500,501,502], supervisor_id: user.id})
		.or(Order.includes(:tecnic, :customer, :city, :status, :substatus).where({status_id: [500,501,502], subsidiary_id: user.subsidiary_id})).order(created_at: :desc).limit(200)
	end

	def self.orders_finished(user)
		@user = User.find(user)
		Order.includes(:tecnic, :customer, :city, :status, :substatus).where({status_id: 504, supervisor_id: @user.id})
		.or(Order.includes(:tecnic, :customer, :city, :status, :substatus).where({status_id: 504, subsidiary_id: @user.subsidiary_id})).order(created_at: :desc).limit(100)
	end

	def self.resquest_orders(subsidiary)
		Order.includes(:tecnic, :customer, :city, :status, :substatus).where({status_id: 505, subsidiary_id: subsidiary}).order(created_at: :desc).limit(100)
	end

	def self.customer_resquest_orders(subsidiary, customer)
		Order.includes(:tecnic, :customer, :city, :status, :substatus).where({subsidiary_id: subsidiary, customer_id: customer}).where.not(status_id: [504, 503]).order(created_at: :desc).limit(200)
	end

	def self.customer_resquest_orders_finished(subsidiary, customer)
		Order.includes(:tecnic, :customer, :city, :status, :substatus).where({status_id: 504, subsidiary_id: subsidiary, customer_id: customer}).order(created_at: :desc).limit(200)
	end

	def self.orders_tecnic(id_tecnic)
	  Order.includes(:tecnic, :customer, :city, :status, :substatus).where(tecnic_id: id_tecnic, status_id: 501 , sync: false).order(created_at: :desc).limit(100)
	end

	def self.order_user_full_name(user)
		"#{User.find(user).first_name} #{User.find(user).last_name}"
	end

	def self.status_order(id_order, status_id) # AGREGAR PARAMETRO thing_id
	  @order = Order.find(id_order)
		@order.update_attribute(:status_id, status_id) # QUITAR ESTA LINEA
		# SE DEBEN USAR ESTAS DE ABAJO, SE ESPERA UN PARAMETRO QUE SEA LA ID DE LA THING
		# ASI SE ASOCIA Y SE CREA TARZABILIDAD DEL HISTORICO DE ORDENES QUE HA TENIDO LA THING
		# DESDE EL LADO DE LA ORDEN
		# order.status_id = 504
		# order.things_ids << thing_id
		# order.save(validate: false)
		@order
	end

	def self.search(subsidiary, search = "", sync = "", status = "", customer = "", tecnic = "", city = "")
		query = Order.includes(:tecnic, :customer, :city, :status, :substatus).where(subsidiary_id: subsidiary)

		if !sync.blank? || !status.blank? || !customer.blank? || !tecnic.blank? || !city.blank?
			query = query.where(sync: sync) if !sync.blank?
			query = query.where(status_id: status) if !status.blank?
			query = query.where(customer_id: customer) if !customer.blank?
			query = query.where(tecnic_id: tecnic) if !tecnic.blank?
			query = query.where(city_id: city) if !city.blank?
			query
		else
			if !query.blank?
				query = query.where("internal_id LIKE ?", "%#{search}%")
				query
			else
				query.order(created_at: :desc).limit(500)
			end
		end
	end

	def self.customer_search(subsidiary, customer, search = "", sync = "", status = "", tecnic = "", city = "")
		query = Order.includes(:tecnic, :customer, :city, :status).where({subsidiary_id: subsidiary, customer_id: customer})

		if !sync.blank? || !status.blank? || !tecnic.blank? || !city.blank?
			query = query.where(sync: sync) if !sync.blank?
			query = query.where(status_id: status) if !status.blank?
			query = query.where(tecnic_id: tecnic) if !tecnic.blank?
			query = query.where(city_id: city) if !city.blank?
			query
		else
			if !query.blank?
				query = query.where("internal_id LIKE ?", "%#{search}%")
				query
			else
				query.order(created_at: :desc).limit(200)
			end
		end
	end

end
