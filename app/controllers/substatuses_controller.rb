class SubstatusesController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor?
  before_action :set_substatus, only: [:show, :edit, :update, :allow_editing?, :destroy]
  before_action :allow_editing?, only: [:edit, :update]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to substatuses_url, notice: "Substatus not found"
  end

  def index
    if params[:format] == "order"
      add_breadcrumb "#{t("base.bar_menu.orders.orders")}/#{t('substatus.index.caption')}"
      @substatus = "order"
      @substatuses_done = Substatus.done(current_user.subsidiary_id)
      @substatuses_pending = Substatus.pending(current_user.subsidiary_id)
      @substatuses_receivable = Substatus.receivable(current_user.subsidiary_id)
      @substatuses_service = Substatus.service(current_user.subsidiary_id)
    else
      add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t('substatus.index.caption')}"
      @substatus = "thing"
      @substatuses_in = Substatus.in(current_user.subsidiary_id)
      @substatuses_out = Substatus.out(current_user.subsidiary_id)
    end

  end

  def edit
  end

  def new
    if params[:format] == "order"
      add_breadcrumb "#{t("base.bar_menu.orders.orders")}/#{t('substatus.index.new')}"
      @substatus = Substatus.new
    else
      add_breadcrumb "#{t("base.bar_menu.things.things")}/#{t('substatus.index.new')}"
      @substatus = Substatus.new
      @substatus.substatus_type = "things_status"
    end

  end

  def create
    allowed = ["504", "506", "507", "508", "300", "301"]
    things = ["300", "301"]
    if allowed.include?(params[:substatus][:status_id])
      if things.include?(params[:substatus][:status_id])
        substatus_created, @substatus = Substatuses::CreateSubstatus.new(params[:substatus], current_user, "thing").process
        substatus_created ? (redirect_to substatuses_url(:thing), notice: "Substatus was successfully created.") : (render :new)
      else
        substatus_created, @substatus = Substatuses::CreateSubstatus.new(params[:substatus], current_user, "order").process
        substatus_created ? (redirect_to substatuses_url(:order), notice: "Substatus was successfully created.") : (render :new)
      end
    else
      render :new
    end
  end

  def update
    allowed = ["504", "506", "507", "508", "300", "301"]
    things = ["300", "301"]
    if allowed.include?(params[:substatus][:status_id])
      if things.include?(params[:substatus][:status_id])
        substatus_created, @substatus = Substatuses::UpdateSubstatus.new(params[:substatus] , @substatus).process
        substatus_created ? (redirect_to substatuses_url(:thing), notice: "Substatus was successfully updated.") : (render :edit)
      else
        substatus_created, @substatus = Substatuses::UpdateSubstatus.new(params[:substatus], @substatus).process
        substatus_created ? (redirect_to substatuses_url(:order), notice: "Substatus was successfully updated.") : (render :edit)
      end
    else
      render :edit
    end
    # if allowed.include?(params[:substatus][:status_id])
    #   substatus_updated, @substatus = Substatuses::UpdateSubstatus.new(params[:substatus], @substatus).process
    #   if substatus_updated
    #     redirect_to substatuses_url, notice: "Substatus was successfully updated."
    #   else
    #     render :edit
    #   end
    # else
    #   render :edit
    # end
  end

  def destroy
    if @substatus.substatus_type.include?("order_status")
      @substatus.destroy
      redirect_to substatuses_url(:order)
    else
      @substatus.destroy
      redirect_to substatuses_url(:thing)
    end
  end

  private
    def set_substatus
      @substatus = Substatus.find_by(slug: params[:slug])
      if params[:action] == 'update'
        @substatus = Substatus.find(params[:id])
      end
    end

    def allow_editing?
      unless @substatus.visible

      else
        redirect_to substatuses_url, alert: "Default substatus, impossible to edit."
      end
    end

end
