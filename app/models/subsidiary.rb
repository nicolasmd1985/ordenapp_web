class Subsidiary < ApplicationRecord
  mount_uploader :urlavatar, UrlavatarUploader
  before_create :set_subsidiary_initials
  # validates_presence_of :identification, :subsidiary_initials
  # validates :identification, uniqueness: true, on: :update

  has_many :users
  has_many :orders
  has_many :things
  has_many :categories
  has_many :components
  has_many :order_rates
  has_many :tools
  belongs_to :status
  belongs_to :corporation

  def self.subsidiary_name(id)
    Subsidiary.find(id).name
  end

  def set_subsidiary_initials
    @subsidiary_initials = ''
    initials = self.name.split(' ')
    if initials.size >= 3
      3.times do |x|
        @subsidiary_initials += initials[x][0].upcase
      end
      self.subsidiary_initials = @subsidiary_initials
    elsif initials.size == 2
      2.times do |x|
        @subsidiary_initials += initials[x][0].upcase
      end
      self.subsidiary_initials = @subsidiary_initials
    else
      @subsidiary_initials = self.name[0..2].upcase
    end
    self.subsidiary_initials = @subsidiary_initials
  end

end
