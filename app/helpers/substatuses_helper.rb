require 'application_helper'

module SubstatusesHelper

  def options_for_select_parent_status_order(selected_value)
    options = parent_statuses_order()
    options_for_select options, selected_value
  end

  def options_for_select_parent_status_thing(selected_value)
    options = parent_statuses_thing()
    options_for_select options, selected_value
  end

end
