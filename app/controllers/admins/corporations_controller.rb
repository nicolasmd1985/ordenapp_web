class Admins::CorporationsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?
  before_action :set_corporation, only: [:show, :edit, :update]
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to admins_subsidiaries_path, notice: "Corporation not found"
  end

  def edit
    if current_user.try(:corporation_id) == @corporation.id

    else
      redirect_to admins_subsidiaries_path, notice:'This corporation not exists.'
    end
  end

  def update
    if @corporation.update(corporation_params)
      redirect_to admins_edit_corporation_url(@corporation), notice: 'Corporation was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corporation
      @corporation = Corporation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def corporation_params
      params.permit(:document_type,:name, :phone, :address, :email, :identification, :corporate_initials, :status_id, :urlavatar)
    end
end
