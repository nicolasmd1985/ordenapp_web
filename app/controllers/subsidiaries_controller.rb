class SubsidiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, except: [:edit, :update]
  before_action :supervisor?, only: [:edit, :update]
  before_action :set_subsidiary, only: [:show, :edit, :update, :destroy]
   skip_before_action :verify_authenticity_token

   rescue_from ActiveRecord::RecordNotFound do |error|
     redirect_to dashboard_url, notice: "Subsidiary not found"
   end

  def index
    @subsidiaries = Subsidiary.where(corporation_id: current_user.try(:corporation_id))
  end

  def show
  end

  def new
    @subsidiary = Subsidiary.new
  end

  def edit
    if current_user.subsidiary_id == @subsidiary.id

    else
      redirect_to dashboard_url, notice:'This subsidiary not exists.'
    end
  end

  def create
    @subsidiary = Subsidiary.new(subsidiary_params)

    if @subsidiary.save
      redirect_to @subsidiary, notice: 'Subsidiary was successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.subsidiary_id == @subsidiary.id
      @subsidiary.corporation_id = current_user.corporation_id
      if @subsidiary.update(subsidiary_params)
        redirect_to edit_subsidiary_url, notice: 'Subsidiary was successfully updated.'
      else
        render :edit
      end
    else
      redirect_to dashboard_url, notice:'This subsidiary not exists.'
    end
  end

  def destroy
    @subsidiary.destroy
    redirect_to subsidiaries_url, notice: 'Subsidiary was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subsidiary
      @subsidiary = Subsidiary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subsidiary_params
      params.require(:subsidiary).permit(:web_page, :document_type, :status_id, :name, :phone, :address, :email, :identification, :password, :subsidiary_initials, :urlavatar)
    end
end
