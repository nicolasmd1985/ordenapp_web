class OrderRate < ApplicationRecord
  before_create :set_slug

  belongs_to :user
  belongs_to :order
  belongs_to :subsidiary

  def set_slug
    begin
			self.slug = SecureRandom.hex
		end while self.class.exists?(slug: self.slug)
  end

  def to_params
    slug
  end

  def self.month_rates(order_rates, year = Date.today.strftime("%Y").to_i)
    @answers = order_rates.select("sum(answer_1) as answer_1_total, ((sum(answer_1) * 20) / count(*)) as answer_1_percentage,
                                    sum(answer_2) as answer_2_total, ((sum(answer_2) * 20) / count(*)) as answer_2_percentage,
                                    sum(answer_3) as answer_3_total, ((sum(answer_3) * 100) / count(*)) as answer_3_percentage,
                                    sum(answer_4) as answer_4_total, ((sum(answer_4) * 100) / count(*)) as answer_4_percentage,
                                    sum(answer_5) as answer_5_total, ((sum(answer_5) * 100) / count(*)) as answer_5_percentage,
                                    count(*) as quantity, order_rates.year, order_rates.month")
                                    .where(year: year).group(:month).order(month: :desc)
    @answers
  end

  def self.year_rates

  end

end
