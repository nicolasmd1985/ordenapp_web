class Notification < ApplicationRecord

  before_create :set_slug

  belongs_to :subsidiary
  belongs_to :supervisor, class_name: "User"

  def set_slug
    begin
      self.slug = SecureRandom.hex
    end while self.class.exists?(slug: self.slug)
  end

  def to_params
    slug
  end

  def self.unread(current_user)
    Notification.where(readed: false, user_id: current_user.id).order(created_at: :desc).limit(30)
  end

  def self.readed(current_user)
    Notification.where(readed: true, user_id: current_user.id).order(created_at: :desc)
  end

  def self.counted(current_user)
    Notification.where(readed: false, user_id: current_user.id).count
  end

  def self.notifications(current_user)
    Notification.where(user_id: current_user.id).order(created_at: :desc)
  end

end
