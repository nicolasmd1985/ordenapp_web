module ThingsHelper

  def options_for_select_status(selected_value)
    options = Status.where(type_status: 'thing_status').map{ |status| [thing_status_humanized(status.description), status.id] }
    options_for_select options, selected_value
  end

  def thing_status_humanized(status)
    @status = status.to_s.gsub(/[\[\]]/, '')
    case @status
    when 'in'
      t('things.status.in')
    when 'out'
      t('things.status.out')
    when 'Stock'
      t('things.status.stock')
    when 'Installed'
      t('things.status.installed')
    when 'Installing'
      t('things.status.installing')
    when 'Replacement'
      t('things.status.replacement')
    when 'On the way'
      t('things.status.on_the_way').html_safe
    when 'Corrective Maintenance'
      t('things.status.corrective_m')
    when 'Preventive Maintenance'
      t('things.status.preventive_m')
    end
  end

  def options_for_select_frecuency(selected_value)
    options = []
    options.insert(0, ['Seleccione...', '0'])
    options << ['Días', 'Dias']
    options << ['Semanal', 'Semanas']
    options << ['Mensual', 'Mensual']
    options << ['Anual', 'Anual']
    options_for_select options, selected_value
  end

  def options_for_select_notification(selected_value)
    options = []
    options.insert(0, ['Seleccione...', '0'])
    options << [t('things.time.minutes'), 'minutes']
    options << [t('things.time.hours'), 'hours']
    options << [t('things.time.days'), 'days']
    options << [t('things.time.weeks'), 'weeks']
    options_for_select options, selected_value
  end

  def options_for_select_customer(subsidiary, selected_value)
    options = User.where(subsidiary_id: subsidiary, role: 2).order(:first_name).map{|user| ["#{user.first_name} #{user.last_name}", user.id]}
    options_for_select options, selected_value
  end

  def options_for_select_thing_category(subsidiary, selected_value)
    options = Category.where(subsidiary_id: subsidiary).where(category_type: "Thing").map{|x| [x.name, x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_thing_substatus(subsidiary, selected_value)
    options = Substatus.in(subsidiary).map{|x| [x.description, x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_thing_weight(selected_value)
    options_for_select Thing.weight_thing, selected_value
  end


end
