class ThingDecorator < Draper::Decorator
  delegate_all

  def basic_info
    {
      id: object.id,
      name: object.name.nil? ? "" : object.name ,
      code_scan: object.code_scan,
      status: object.status.description.nil? ?  "" : object.status.description  ,
      subsidiary: object.subsidiary.name.nil? ? "" : object.subsidiary.name,
      state: object.substatus.nil? ? "" : object.substatus.description  ,
      category: object.category.nil? ? "" : object.category.name  ,
      stock: object.stock.nil? ? "" : object.stock.to_s  ,
      price: object.final_price.nil? ? "" : object.final_price ,
      photos: photos,
      description: object.description.nil? ? "" : object.description
    }
  end

end
