class ToolsController < ApplicationController
  before_action :authenticate_user!
  before_action :supervisor?
  before_action :set_tool, only: [:show, :edit, :update, :destroy, :create_comment]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to dashboard_url, notice: I18n.t('back_messages.not_found')
  end

  def index
    if (params[:search].present? && !params[:search].blank?) || (params[:status].present? && !params[:status].blank?) || (params[:tecnic].present? && !params[:tecnic].blank?)
      @tools = Tool.search(current_user.try(:subsidiary_id), params[:tecnic], params[:status], params[:search])
    else
      @tools = Tool.list(current_user.try(:subsidiary_id))
    end
    @status = params[:status].present? ? params[:status] : ''
    @tecnic = params[:tecnic].present? ? params[:tecnic] : ''
    add_breadcrumb "#{t("base.bar_menu.tools.tools")}/#{t("base.bar_menu.tools.list")}"

  end

  def show
    if @tool.try(:subsidiary_id) == current_user.subsidiary_id
      @comments = @tool.try(:comments).order(created_at: :desc).limit(5)
    else
      redirect_to tools_url, notice: I18n.t('back_messages.no_registered', resource: "Tool")
    end
  end

  def new
    @tool = Tool.new
    @edit = true
    add_breadcrumb "#{t("base.bar_menu.tools.tools")}/#{t("base.bar_menu.tools.new")}"

  end

  def edit
    if @tool.try(:subsidiary_id) == current_user.subsidiary_id
      @edit = false
    else
      redirect_to tools_url, notice: I18n.t('back_messages.no_registered', resource: "Tool")
    end
  end

  def create
    @tool = Tool.new(tool_params)
    @tool.subsidiary_id = current_user.subsidiary_id
    @tool.user_id = current_user.id
    check_code = @tool.validate_code_scan(params[:tool][:code_scan], current_user.subsidiary_id, @tool)

    if check_code
      redirect_to new_tool_url, notice: I18n.t('back_messages.code_scan_uniq')
      return
    end

    if params[:tool][:status_id].to_i == 400 && params[:tool][:tecnic_id].blank?
      redirect_to new_tool_url, alert: I18n.t('back_messages.tools.responsible_error')
    else
      if @tool.save
        @tool.update(code_scan: @tool.slug) if @tool.code_scan.blank?
        @tool.update(tecnic_id: nil) if @tool.status_id != 400
        Tools::CreateComment.new(@tool, current_user, params[:tool]).process

        redirect_to show_tool_url(@tool.slug), notice: I18n.t('back_messages.created', resource: "Tool")
      else
        render :new
      end
    end

  end

  def update
    if params[:tool][:status_id].to_i == 400 && params[:tool][:tecnic_id].blank?
      redirect_to edit_tool_url(@tool.slug), alert: I18n.t('back_messages.tools.responsible_error')
    else
      if @tool.update(tool_params)
        @tool.update(status_id: 400) if !params[:tool][:tecnic_id].blank?
        @tool.update(tecnic_id: nil) if @tool.status_id != 400
        @tool.update(status_id: 401) if @tool.tecnic_id.blank?
        Tools::CreateComment.new(@tool, current_user, params[:tool]).process

        redirect_to show_tool_url(@tool.slug), notice: I18n.t('back_messages.updated', resource: "Tool")
      else
        render :edit
      end
    end
  end

  def create_comment
    if params[:tecnic_id].blank? && params[:status_id].to_i == 400
      redirect_to show_tool_url(@tool.slug), alert: I18n.t('back_messages.tools.responsible_error', resource: "Tool")
    elsif @tool.status_id == params[:status_id].to_i && @tool.tecnic_id == params[:tecnic_id].to_i
      redirect_to show_tool_url(@tool.slug), notice: I18n.t('back_messages.nothing')
    elsif @tool.status_id == params[:status_id].to_i && @tool.tecnic_id != params[:tecnic_id].to_i
      commented, comment = create_comment_tool(@tool, params)
      if commented
        redirect_to show_tool_url(@tool.slug), notice: I18n.t('back_messages.field_updated', field: "Status")
      else
        redirect_to show_tool_url(@tool.slug), alert: I18n.t('back_messages.tools.error_field', field: "Status")
      end
    elsif @tool.status_id == params[:status_id].to_i
      redirect_to show_tool_url(@tool.slug), notice: I18n.t('back_messages.nothing')
    else
      commented, comment = create_comment_tool(@tool, params)
      if commented
        redirect_to show_tool_url(@tool.slug), notice: I18n.t('back_messages.field_updated', field: "Status")
      else
        redirect_to show_tool_url(@tool.slug), alert: I18n.t('back_messages.tools.error_field', field: "Status")
      end
    end
  end

  def create_comment_tool(tool, params)
    @tool = tool
    @tool.update(status_id: params[:status_id])
    @tool.update(tecnic_id: params[:tecnic_id]) if !params[:tecnic_id].blank?
    @tool.update(tecnic_id: nil) if @tool.status_id != 400

    commented, comment = Tools::CreateComment.new(@tool, current_user, params).process

    [commented, comment]
  end

  def destroy
    @tool.destroy
    redirect_to tools_url, notice: I18n.t('back_messages.destroyed', resource: "Tool")
  end

  private
    def set_tool
      @tool = Tool.find_by(slug: params[:slug])
      if params[:action] == 'update'
        @tool = Tool.find(params[:id])
      end
    end

    def tool_params
      params.require(:tool).permit(:user_id, :status_id, :name, :description, :code_scan, :daily_use, :tecnic_id, :subsidiary_id)
    end
end
