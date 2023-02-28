module MaintenancesHelper

  def options_for_select_frequency(selected_value)
    options = []
    options.insert(0, [t('maintenance.frequency.day'), "day"])
    options.insert(1, [t('maintenance.frequency.week'), "week"])
    options.insert(2, [t('maintenance.frequency.month'), "month"])
    options.insert(3, [t('maintenance.frequency.quarterly'), "quarterly"])
    options.insert(4, [t('maintenance.frequency.biannual'), "biannual"])
    options.insert(5, [t('maintenance.frequency.year'), "year"])
    options_for_select options, selected_value
  end

end
