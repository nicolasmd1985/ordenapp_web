class Reports::FilterReport

  def initialize(orders, params)
    @orders = orders
    @params = params
  end

  def process
    if @orders.count > 0
      from_date = !@params[:from_date].blank? ? @params[:from_date] : nil
      to_date = !@params[:to_date].blank? ? @params[:to_date] : Date.today.strftime("%d-%m-%Y")
      
      @orders.where(created_at: from_date.to_datetime.beginning_of_day..to_date.to_datetime.end_of_day)
    else
      @orders
    end
  end

end
