class CorporationsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, except: [:create]
  before_action :set_corporation, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to dashboard_url, notice: "Corporation not found"
  end

  def index
    @corporations = Corporation.all
  end

  def show
  end

  def new
    @corporation = Corporation.new
  end

  def edit
    if current_user.subsidiary.corporation_id == @corporation.id

    else
      redirect_to dashboard_url, notice:'This corporation not exists.'
    end
  end

  def create
    @corporation = Corporation.new(corporation_params)

    if @corporation.save
      redirect_to @corporation, notice: 'Corporation was successfully created.'
    else
      render :new
    end

  end

  def update
    respond_to do |format|
      if @corporation.update(corporation_params)
        format.html { redirect_to @corporation, notice: 'Corporation was successfully updated.' }
        format.json { render :show, status: :ok, location: @corporation }
      else
        format.html { render :edit }
        format.json { render json: @corporation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @corporation.destroy
    redirect_to corporations_url, notice: 'Corporation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corporation
      @corporation = Corporation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def corporation_params
      params.require(:corporation).permit(:name, :phone, :address, :email, :identification, :corporate_initials, :status_id)
    end
end
