class Api::V2::CategoriesController < ApiController
  before_action :authorize_request

  def index
    @categories = Category.where(subsidiary_id: params[:subsidiary_id], category_type: "Thing").order(created_at: :desc)
    render json: CategoriesDecorator.decorate(Category).categories_decorator(@categories), status: :ok
  end

end
