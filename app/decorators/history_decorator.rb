class HistoryDecorator < Draper::Decorator
  delegate_all

  def basic_info
    {
      id: object.id,
      order: object.try(:order).try(:id),
      origin: object.origin,
      tecnic: "#{object.try(:tecnic).try(:first_name)} #{object.try(:tecnic).try(:last_name)}" ,
      description: object.description,
      photos: object.photos,
      created_at: object.created_at.strftime("%Y-%m-%d - %T")
    }
  end

end
