require "application_helper.rb"

class CategoriesDecorator < Draper::Decorator
  delegate_all

  def categories_decorator(categories)
    records = []
    categories.each do |category|
      records.push({
          id: category.id,
          name: category.name,
          subsidiary_id: category.subsidiary_id
        })
    end
    records
  end

end
