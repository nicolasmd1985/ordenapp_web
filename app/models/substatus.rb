class Substatus < ApplicationRecord
  before_create :set_slug

  validates_presence_of :description

  has_many :orders
  has_many :things, dependent: :delete_all
  has_many :histories


  belongs_to :status
  belongs_to :subsidiary, optional: true

  def self.done(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 504)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 504)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.pending(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 506)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 506)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.receivable(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 507)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 507)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.service(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 508)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 508)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.done(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 504)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 504)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.pending(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 506)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 506)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.receivable(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 507)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 507)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.service(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 508)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 508)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.in(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 300)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 300)
    substatuses = internal_substatuses + default_substatuses
  end

  def self.out(subsidiary_id)
    default_substatuses = Substatus.where(visible: true, status_id: 301)
    internal_substatuses = Substatus.where(subsidiary_id: subsidiary_id, status_id: 301)
    substatuses = internal_substatuses + default_substatuses
  end

  def set_slug
    begin
      self.slug = SecureRandom.hex
    end while self.class.exists?(slug: self.slug)
  end

  def set_slug
    begin
      self.slug = SecureRandom.hex
    end while self.class.exists?(slug: self.slug)
  end

  def to_params
    slug
  end

end
