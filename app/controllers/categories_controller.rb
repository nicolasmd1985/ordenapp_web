class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :supervisor?

  def index
    if params[:format] == "order"
      add_breadcrumb "#{t("base.bar_menu.orders.orders")}/#{t("base.bar_menu.categories.list")}"
      @categories = Category.where(subsidiary_id: current_user.subsidiary_id, category_type: "Order").order(created_at: :desc)
    else
      add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t("base.bar_menu.categories.list")}"
      @categories = Category.where(subsidiary_id: current_user.subsidiary_id, category_type: "Thing").order(created_at: :desc)
    end
  end

  def show
    if @category.subsidiary_id == current_user.subsidiary_id

    else
      redirect_to categories_url, notice: "This category is not registered in your subsidiary"
    end
  end

  def new
    @category = Category.new
    if params[:format] == "order"
      add_breadcrumb "#{t("base.bar_menu.orders.orders")}/#{t("base.bar_menu.categories.new")}"
      @category.category_type = "Order"
    else
      add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t("base.bar_menu.categories.new")}"
      @category.category_type = "Thing"
    end
  end

  def edit
    if @category.subsidiary_id == current_user.subsidiary_id

    else
      redirect_to categories_url, notice: "This category is not registered in your subsidiary"
    end
  end

  def create
    @category = Category.new(category_params)
    @category.subsidiary_id = current_user.subsidiary_id

    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def update
    @category.subsidiary_id = current_user.subsidiary_id

    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :category_type)
    end
end
