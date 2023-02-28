class Tools::CreateComment

  def initialize(tool, current_user, params)
    @tool = tool
    @params = params
    @current_user = current_user
  end

  def process
    comment = ToolComment.new()
    comment.comment = "#{@params[:comment]} - [#{@params[:status_id] ? status_humanized(@params[:status_id]) : status_humanized(@tool.status_id)}]"
    comment.user = @current_user
    comment.tool = @tool

    success = comment.save

    if success
      [success, comment]
    else
      success = false
      [success, false]
    end
  end

  private
    def status_humanized(status)
      @status = status.to_i
      case @status
      when 400
        I18n.t('tools.status.assigned')
      when 401
        I18n.t('tools.status.stock')
      when 402
        I18n.t('tools.status.replacement')
      when 404
        I18n.t('tools.status.lost')
      end
    end

end
