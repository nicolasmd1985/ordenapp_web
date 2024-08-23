class User < ApplicationRecord
  mount_uploader :urlavatar, UrlavatarUploader

  # Callbacks
  before_save :verify_document_number

  # Associations
  has_many :orders, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :tools, dependent: :delete_all
  has_many :positions, dependent: :delete_all
  has_many :things, dependent: :delete_all
  has_many :order_rates, dependent: :delete_all
  has_many :position_logs, dependent: :delete_all

  belongs_to :city, optional: true
  belongs_to :subsidiary, optional: true
  belongs_to :corporation
  belongs_to :status

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validate :password_complexity

  # Enums
  enum role: { tecnic: 0, supervisor: 1, customer: 2, admin: 3 }

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Scopes
  scope :by_subsidiary_and_role, ->(subsidiary, role) { where(subsidiary_id: subsidiary, role: role) }

  # Class methods
  def self.users_count(subsidiary, role)
    by_subsidiary_and_role(subsidiary, role).count
  end

  def self.users_collaborators(subsidiary, role)
    by_subsidiary_and_role(subsidiary, role).limit(100).order(created_at: :desc)
  end

  def self.active_orders(id, subsidiary)
    joins("INNER JOIN orders ON users.id = orders.tecnic_id")
      .where(id: id, subsidiary_id: subsidiary)
      .where(orders: { status_id: [501, 502] })
      .count
  end

  def self.search(subsidiary, role, query = "", city = "")
    results = by_subsidiary_and_role(subsidiary, role)
    results = results.where(city_id: city) if city.present?
    
    if query.present?
      results = results.where("first_name LIKE :query OR last_name LIKE :query OR document_number LIKE :query OR email LIKE :query OR phone_number_1 LIKE :query", query: "%#{query}%")
    end

    results.order(created_at: :desc)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      name_array = auth.info.name.split(/ /, 2)
      user.first_name = name_array[0]
      user.last_name = name_array[1]
    end
  end

  # Instance methods
  def orders
    Order.where("#{role}_id" => id)
  end

  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end

  private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase, 1 number and 1 special character'
  end

  def verify_document_number
    document_number = self.document_number.presence || self.email
    check_document_number = User.where(document_number: document_number, subsidiary_id: self.subsidiary_id)

    if check_document_number.count > 1 || (check_document_number.count == 1 && check_document_number.first != self)
      self.errors.add(:alert, "Document number duplicated.")
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  # Class methods for choices
  def self.document_type_values
    CustomerChoices['document_type_colombia']
  end

  def self.customer_type_values
    CustomerChoices['customer_priority']
  end
end