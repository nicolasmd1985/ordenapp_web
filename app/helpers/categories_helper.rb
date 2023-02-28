module CategoriesHelper

  def options_for_select_category_type(selected_value)
    options = []
    options << [t('category.types.order'), 'Order']
    options << [t('category.types.thing'), 'Thing']
    options_for_select options, selected_value
  end

  def category_type_humanized(status)
    @status = status.to_s.gsub(/[\[\]]/, '')
    case @status
    when 'Order'
      t('category.types.order')
    when 'Thing'
      t('category.types.thing')
    when 'Uncategorized'
      t('category.types.uncat')
    end
  end
end
