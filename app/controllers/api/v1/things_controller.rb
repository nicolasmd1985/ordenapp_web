class Api::V1::ThingsController < ApiController
  before_action :authorize_request, except: [:search]
  before_action :set_thing, only: [:show, :update]

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  def index
    @things = Thing.joins(:histories).select('things.*, histories.*').distinct
    render json: @things, status: :ok
  end

  def show
    render json: @thing, status: :ok
  end

  def search
    @things = Things::Search.search_devise(params)
    render json: {data: @things}, status: :ok
  end

  def update
    if @thing.update!(things_params)
      render json: @thing, status: :ok
    else
      render json: {errors: @thing.full_messages}, status: :unprocessable_entity
    end
  end

  def create
  end

  def histories
    # histories/84f41f2d02f8c2fcad401844232668b5
    @thing = Thing.where({code_scan: params[:code_scan], subsidiary_id: params[:subsidiary_id].present? ? params[:subsidiary_id] : current_user.subsidiary_id}).first
    if @thing
      @thing_decorated = ThingDecorator.decorate(@thing).basic_info
      render json: {data: {thing: @thing_decorated}}, status: :ok
    else
      render json: {message: 'Not found'}, status: :unprocessable_entity
    end
  end

  def set_thing
    @thing = Thing.find(params[:id])
  end

  def out_thing_search
    @thing = Thing.where({code_scan: params[:thing], subsidiary_id: current_user.subsidiary_id}).first
    @customer = Order.find(params[:order]).customer_id
    if @thing && @customer
      @out_thing = OutThing.where({thing: @thing, customer_id: @customer}).first
      if @out_thing.present?
        @thing_decorated = ThingOutDecorator.decorate(@out_thing).basic_info
        render json: {data: {thing: @thing_decorated}}, status: :ok
      else
        @thing_decorated = ThingDecorator.decorate(@thing).basic_info
        render json: {data: {thing: @thing_decorated}}, status: :ok
      end
    elsif @thing
      @thing_decorated = ThingDecorator.decorate(@thing).basic_info
      render json: {data: {thing: @thing_decorated}}, status: :ok
    else
      render json: {message: 'Not found'}, status: :unprocessable_entity
    end
  end

  def things_params
    params.permit(:name, :description, :code_scan, :status_id, :order_id, :photos, :subsidiary_id, :user_id, :category_id)
  end

end
