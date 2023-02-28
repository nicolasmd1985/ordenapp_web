class User < ApplicationRecord
  mount_uploader :urlavatar, UrlavatarUploader
  before_save :verify_document_number
  # has_secure_password
  # validates :document_number, presence: false, on: :update
  # validates :document_number, uniqueness: true, on: :update
  validates :email, presence: true, if: -> { !self.email.blank? }
  validates :email, uniqueness: true, if: -> { !self.email.blank? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { !self.email.blank? }
  validates :password,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }
  # validate :password_complexity

  has_many :orders, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :tools, dependent: :delete_all
  has_many :positions, dependent: :delete_all
  has_many :things, dependent: :delete_all
  has_many :order_rates, dependent: :delete_all

  belongs_to :city, optional: true
  belongs_to :subsidiary, optional: true
  belongs_to :corporation
  belongs_to :status

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,# :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
         #:confirmable, :lockable, :timeoutable,

  enum role: {tecnic: 0, supervisor: 1, customer: 2, admin: 3}

  def orders
  	role = self.role
  	Order.where("#{role}_id" => self.id)
  end

  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

  def generate_jwt
    JWT.encode({ id: id,
                exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

  def self.users_count(subsidiary, role)
    User.where({role: role, subsidiary_id: subsidiary}).count
  end

  def self.users_colaborators(subsidiary, role)
    User.where({role: role, subsidiary_id: subsidiary}).limit(100).order(created_at: :desc)
  end

  def self.active_orders(id, subsidiary)
    User.joins("INNER JOIN orders ON users.id = orders.tecnic_id").where(["users.id = #{id} AND users.subsidiary_id = #{subsidiary} AND orders.status_id IN (501, 502)"]).count
  end

  def self.search(subsidiary, role, query = "", city = "")
    query_base = User.where({subsidiary_id: subsidiary, role: role})

    @query =  if !query.blank? && !city.blank?
                query_base.where(city_id: city).where("first_name LIKE ?", "%#{query}%")
                .or(query_base.where(city_id: city).where("last_name LIKE ?", "%#{query}%"))
                .or(query_base.where(city_id: city).where("document_number LIKE ?", "%#{query}%"))
                .or(query_base.where(city_id: city).where("email LIKE ?", "%#{query}%"))
                .or(query_base.where(city_id: city).where("phone_number_1 LIKE ?", "%#{query}%")).order(created_at: :desc)
              else
                if !query.blank?
                  query_base.where("first_name LIKE ?", "%#{query}%")
                  .or(query_base.where("last_name LIKE ?", "%#{query}%"))
                  .or(query_base.where("document_number LIKE ?", "%#{query}%"))
                  .or(query_base.where("email LIKE ?", "%#{query}%"))
                  .or(query_base.where("phone_number_1 LIKE ?", "%#{query}%")).order(created_at: :desc)
                else
                  query_base.where(city_id: city)
                end
              end
  end

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{1,70}$/
    errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 number and 1 special character'
  end

  # update profile or create user execute once time, new document_number is in self
  # update user execute twice, first: old document_number isn't in self, second: new document_number is in self
  # regiter validate three times, as document_number is null search by self.email as document_number
  # this prevent record with null docu and not allowing registration
  # in that moment validate uniqueness
  def verify_document_number
    # uniqueness document_number by subsidiary
    document_number = self.document_number? ? self.document_number : self.email
    check_document_number = User.where(document_number: document_number, subsidiary_id: self.subsidiary_id)

    # One or zero coincidences
    if check_document_number.count <= 1
      case check_document_number.count
      when 0
        # if there aren't records whit that value
      when 1
        # if is found one and is the same record
        if check_document_number.first == self
        # if is a diferent record
        else
          # rollback message
          self.errors.add(:alert, "Document number duplicated.")
          raise ActiveRecord::RecordInvalid.new(self)
        end
      end
    else
      # rollback message
      self.errors.add(:alert, "Document number duplicated.")
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def self.document_type_values
    CustomerChoices['document_type_colombia']
  end

  def self.customer_type_values
    CustomerChoices['customer_priority']
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      name_array = auth.info.name.split(/ /, 2)
      user.first_name = name_array[0]
      user.last_name = name_array[1]   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

end
