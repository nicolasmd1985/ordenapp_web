class Tool < ApplicationRecord
  before_create :set_slug

  validates_presence_of :name, :description

  belongs_to :user
  belongs_to :status
  belongs_to :subsidiary
  belongs_to :tecnic, class_name: 'User', optional: true

  has_many :comments, class_name: "ToolComment"

  def set_slug
		begin
			self.slug = SecureRandom.hex(9)
		end while self.class.exists?(slug: self.slug)
	end

  def to_params
		slug
	end

  def self.list(subsidiary)
    Tool.includes(:user, :tecnic, :subsidiary, :status).where(subsidiary_id: subsidiary)
  end

  def self.search(subsidiary, tecnic = "", status = "", query = "")
    query_base = Tool.includes(:user, :tecnic, :subsidiary, :status).where(subsidiary_id: subsidiary).order(created_at: :desc).limit(100)

    @query =  if !tecnic.blank? && !status.blank? && !query.blank?
                query_base.where(tecnic_id: tecnic).where(status_id: status)
                .or(query_base.where(tecnic_id: tecnic).where(status_id: status).where("name LIKE ?", "%#{query}%"))
                .or(query_base.where(tecnic_id: tecnic).where(status_id: status).where("description LIKE ?", "%#{query}%")).order(created_at: :desc)
              elsif !query.blank? && (!tecnic.blank? || !status.blank?)
                if !tecnic.blank?
                  query_base.where(tecnic_id: tecnic).where("name LIKE ? ", "%#{query}%")
                  .or(query_base.where(tecnic_id: tecnic).where("description LIKE ? ", "%#{query}%")).order(created_at: :desc)
                else
                  query_base.where(status_id: status).where("name LIKE ? ", "%#{query}%")
                  .or(query_base.where(status_id: status).where("description LIKE ? ", "%#{query}%")).order(created_at: :desc)
                end
              elsif !tecnic.blank? && !status.blank?
                query_base.where(tecnic_id: tecnic).where(status_id: status).order(created_at: :desc)
              elsif !tecnic.blank? || !status.blank?
                if !tecnic.blank?
                  query_base.where(tecnic_id: tecnic).order(created_at: :desc)
                else
                  query_base.where(status_id: status).order(created_at: :desc)
                end
              elsif !query.blank?
                query_base.where("name LIKE ? ", "%#{query}%")
                .or(query_base.where("description LIKE ? ", "%#{query}%")).order(created_at: :desc)
              end
  end

  def validate_code_scan(code_scan, subsidiary_id, tool)
    code_scan.delete!("\t")
    check_code = Tool.where({code_scan: code_scan, subsidiary_id: subsidiary_id}).first
    if check_code
      return check_code != tool
    else
      return false
    end
  end

end
