module UsersHelper

  def options_for_select_city(subsidiary, role, selected_value)
    cities = User.where({subsidiary_id: subsidiary, role: role}).map{|x| x.city_id}
    options = City.where(id: cities).order(:name).map{|x| [x.name, x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_subsidiary(corporation, selected_value)
    options = Subsidiary.where({corporation_id: corporation, status_id: 100}).map{|x| [x.name, x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_document_type(selected_value)
    options_for_select User.document_type_values, selected_value
  end

  def options_for_select_priority_user(selected_value)
    options_for_select User.customer_type_values, selected_value
  end

end
