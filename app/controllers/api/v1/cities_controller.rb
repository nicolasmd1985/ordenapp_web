class Api::V1::CitiesController < ApiController
  before_action :authorize_request
  before_action :set_city, only: [:show]

  def index
    @cities = City.all.order(:name)
    render json: @cities, status: :ok
  end

  def show
    render json: @city, status: :ok
  end

  private
  def set_city
    @city = City.find(params[:id])
  end
end
