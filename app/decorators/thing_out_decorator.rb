class ThingOutDecorator < Draper::Decorator
  delegate_all

  def basic_info
    {
      id: object.thing.id,
      name: object.thing.name.nil? ? "" : object.thing.name ,
      code_scan: object.thing.code_scan,
      status: object.thing.status.description.nil? ?  "" : object.thing.status.description  ,
      subsidiary: object.thing.subsidiary.name.nil? ? "" : object.thing.subsidiary.name,
      state: object.thing.substatus.nil? ? "" : object.thing.substatus.description  ,
      category: object.thing.category.nil? ? "" : object.thing.category.name  ,
      stock: object.stock.nil? ? "" : object.stock.to_s  ,
      price: object.thing.final_price.nil? ? "" : object.thing.final_price ,
      description: object.thing.description.nil? ? "" : object.thing.description,
      histories: object.histories.map{|x| HistoryDecorator.decorate(x).basic_info}
    }
  end

end
