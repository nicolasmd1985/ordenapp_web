class Thing < ApplicationRecord

  mount_uploader :urlavatar, UrlavatarUploader

  serialize :photos,Array
  serialize :order_ids, Array
  serialize :position_ids, Array

  before_create :set_slug

  validates_presence_of :name

  belongs_to :status
  belongs_to :substatus, optional: true
  belongs_to :order, optional: true
  belongs_to :subsidiary

  # customer relationship
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :category, optional: true

  # has_many :histories
  has_many :positions
  has_many :out_things
  has_many :components, class_name: 'Things::Component', dependent: :delete_all


  # this method define the many_to_many relationship from things to orders
  def orders
    orders = self.order_ids
    Order.where(id: orders)
  end

  def self.things(supervisor)
    Thing.joins("INNER JOIN orders ON orders.id = things.order_id WHERE orders.supervisor_id = #{supervisor}")
  end

  def self.list(subsidiary)
    Thing.includes(:order, :subsidiary, :user, :category, :substatus).where(subsidiary_id: subsidiary).order(created_at: :desc).limit(20)
  end

  def self.customer_list(customer_id)
    Thing.includes(:order, :subsidiary, :user).where(user_id: customer_id).order(created_at: :desc).limit(20)
  end

  def set_slug
		begin
			self.slug = SecureRandom.hex(9)
		end while self.class.exists?(slug: self.slug)
	end

	def to_params
		slug
	end

	def self.create_slugs
   Thing.all.each do |thing|
    thing.set_slug
		thing.save!
   end
  end

  def self.weight_thing
    ThingChoices['thing_weight']
  end

  def validate_code_scan(code_scan, subsidiary_id, thing)
    code_scan.delete!("\t")
    check_code = Thing.where({code_scan: code_scan, subsidiary_id: subsidiary_id}).first
    if check_code
      return check_code != thing
    else
      return false
    end
  end

  def set_internal_id
    category = self.category_id ? Category.find(self.category_id) : Category.find_by(name: "Dispositivo")
    category_initials = category.name[0..2].upcase
    sequence = Thing.where({subsidiary_id: self.subsidiary_id, category_id: self.category_id}).count + 1
    self.internal_id = "#{category_initials}-#{sequence}"
  end

  def self.search(subsidiary, query = "", customer = "", status = "")
    query_base = Thing.includes(:order, :subsidiary, :user).where(subsidiary_id: subsidiary)

    @query =  if !customer.blank? && !status.blank? && !query.blank?
                query_base.where(user_id: customer).where(status_id: status)
                .or(query_base.where(user_id: customer).where(status_id: status).where("name LIKE ? ", "%#{query}%"))
                .or(query_base.where(user_id: customer).where(status_id: status).where("description LIKE ? ", "%#{query}%"))
                .or(query_base.where(user_id: customer).where(status_id: status).where("internal_id LIKE ? ", "%#{query}%"))
                .or(query_base.where(user_id: customer).where(status_id: status).where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
              elsif !query.blank? && (!customer.blank? || !status.blank?)
                if !customer.blank?
                  query_base.where(user_id: customer).where("name LIKE ? ", "%#{query}%")
                  .or(query_base.where(user_id: customer).where("description LIKE ? ", "%#{query}%"))
                  .or(query_base.where(user_id: customer).where("internal_id LIKE ? ", "%#{query}%"))
                  .or(query_base.where(user_id: customer).where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
                else
                  query_base.where(status_id: status).where("name LIKE ? ", "%#{query}%")
                  .or(query_base.where(status_id: status).where("description LIKE ? ", "%#{query}%"))
                  .or(query_base.where(status_id: status).where("internal_id LIKE ? ", "%#{query}%"))
                  .or(query_base.where(status_id: status).where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
                end
              elsif !customer.blank? && !status.blank?
                query_base.where(user_id: customer).where(status_id: status).order(created_at: :desc)
              elsif !customer.blank? || !status.blank?
                if !customer.blank?
                  query_base.where(user_id: customer).order(created_at: :desc)
                else
                  query_base.where(status_id: status).order(created_at: :desc)
                end
              elsif !query.blank?
                query_base.where("name LIKE ? ", "%#{query}%")
                .or(query_base.where("description LIKE ? ", "%#{query}%"))
                .or(query_base.where("internal_id LIKE ? ", "%#{query}%"))
                .or(query_base.where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
              end

  end

  def self.customer_search(customer_id, query = "", status = "")
    query_base = Thing.includes(:order, :subsidiary, :user).where(user_id: customer_id)

    @query =  if !status.blank? && !query.blank?
                query_base.where(status_id: status)
                .or(query_base.where(status_id: status).where("name LIKE ? ", "%#{query}%"))
                .or(query_base.where(status_id: status).where("description LIKE ? ", "%#{query}%"))
                .or(query_base.where(status_id: status).where("internal_id LIKE ? ", "%#{query}%"))
                .or(query_base.where(status_id: status).where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
              elsif !query.blank? || !status.blank?
                if !query.blank?
                  query_base.where("name LIKE ? ", "%#{query}%")
                  .or(query_base.where("description LIKE ? ", "%#{query}%"))
                  .or(query_base.where("internal_id LIKE ? ", "%#{query}%"))
                  .or(query_base.where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
                else
                  query_base.where(status_id: status).order(created_at: :desc)
                end
              end

  end

end
