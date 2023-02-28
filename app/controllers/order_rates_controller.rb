class OrderRatesController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor?, except: [:edit, :update]
  before_action :customer?, only: [:edit, :update]
  before_action :set_order_rate, only: [:edit, :update]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to root_url, alert: "Resource not found."
  end

  def index
    @order_rates = OrderRate.where(subsidiary_id: current_user.subsidiary_id, active: false)
    questions = @order_rates.last
    if questions
      @question_1 = questions.question_1
      @question_2 = questions.question_2
      @question_3 = questions.question_3
      @question_4 = questions.question_4
      @question_5 = questions.question_5
      @answers = OrderRate.month_rates(@order_rates)
    end
  end

  def edit
    if !@order_rate.active
      redirect_to customers_dashboard_path, notice: "Ésta encuesta ya fue respondida. Gracias."
    end
  end

  def update
    if !@order_rate.active
      render :edit
    else
      order_rate_updated, @order_rate = Orders::Rates::UpdateRate.new(@order_rate, params[:order_rate]).process
      if order_rate_updated
        redirect_to customers_dashboard_path, notice: "Gracias por responder la encuesta"
      else
        redirect_to edit_order_rate_url(@order_rate.slug)
      end
    end
  end

  private
    def set_order_rate
      @order_rate = OrderRate.find_by(slug: params[:slug])
      if params[:action] == 'update'
        @order_rate = OrderRate.find(params[:id])
      end
    end
end
