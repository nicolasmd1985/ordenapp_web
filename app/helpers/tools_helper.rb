module ToolsHelper

  def options_for_select_tool_status(selected_value)
    options = Status.where(type_status: 'tools_status').map{ |status| [tool_status_humanized(status.description), status.id] }
    options_for_select options, selected_value
  end

  def tool_status_humanized(status)
    @status = status.to_s.gsub(/[\[\]]/, '')
    case @status
    when 'Assigned'
      t('tools.status.assigned')
    when 'Stock'
      t('tools.status.stock')
    when 'Replacement'
      t('tools.status.replacement')
    when 'Lost'
      t('tools.status.lost')
    end
  end

  def options_for_select_tool_tecnic(subsidiary, selected_value)
    options = User.where(subsidiary_id: subsidiary, role: 0, active: true).map{ |x| ["#{x.first_name} #{x.last_name}", x.id] }
    options_for_select options, selected_value
  end

end
