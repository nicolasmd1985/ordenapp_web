class Corporation < ApplicationRecord
  mount_uploader :urlavatar, UrlavatarUploader
  before_create :set_corporate_initials

  validates :identification, uniqueness: true, on: :update

  belongs_to :status
  has_many :subsidiaries


  def self.corporation_name(id)
    Corporation.find(id).name
  end

  def set_corporate_initials
    @corporate_initials = ''
    initials = self.name.split(' ')
    if initials.size >= 3
      3.times do |x|
        @corporate_initials += initials[x][0].upcase
      end
      self.corporate_initials = @corporate_initials
    elsif initials.size == 2
      2.times do |x|
        @corporate_initials += initials[x][0].upcase
      end
      self.corporate_initials = @corporate_initials
    else
      @corporate_initials = self.name[0..2].upcase
    end
    self.corporate_initials = @corporate_initials
  end

  def self.document_type_values
    CustomerChoices['document_type_colombia']
  end

end
