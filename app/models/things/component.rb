module Things
  class Component < ApplicationRecord
    before_create :set_slug

    validates_presence_of :name, :description

    belongs_to :thing, optional: true
    belongs_to :subsidiary

    def set_slug
  		begin
  			self.slug = SecureRandom.hex
  		end while self.class.exists?(slug: self.slug)
  	end

    def to_params
      slug
    end

    def validate_code_scan(code_scan, subsidiary_id, component)
      code_scan.delete!("\t")
      check_code = Component.where({code_scan: code_scan, subsidiary_id: subsidiary_id}).first
      if check_code
        return check_code != component
      else
        return false
      end
    end

    def self.list(subsidiary_id)
      Component.includes(:thing, :subsidiary).where(subsidiary_id: subsidiary_id).order(:name)
    end

    def self.search(subsidiary_id, query = "", thing = "")
      query_base = Component.includes(:thing, :subsidiary).where(subsidiary_id: subsidiary_id)

      @query =  if !thing.blank? && !query.blank?
                  query_base.where(thing_id: thing)
                  .or(query_base.where(thing_id: thing).where("name LIKE ? ", "%#{query}%"))
                  .or(query_base.where(thing_id: thing).where("description LIKE ? ", "%#{query}%"))
                  .or(query_base.where(thing_id: thing).where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
                elsif !query.blank? || !thing.blank?
                  if !query.blank?
                    query_base.where("name LIKE ? ", "%#{query}%")
                    .or(query_base.where("description LIKE ? ", "%#{query}%"))
                    .or(query_base.where("code_scan LIKE ? ", "%#{query}%")).order(created_at: :desc)
                  else
                    query_base.where(thing_id: thing).order(created_at: :desc)
                  end
                end
    end

  end
 
end
