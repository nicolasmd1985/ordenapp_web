module Customers
  module OrdersHelper

    def order_city_options(selected_value)
      options = City.all.collect{ |x| [x.name , x.id] }
      options_for_select options, selected_value
    end

    def customer_options_for_select_sync(selected_value)
      options = []
      options << [t('orders.sync.sync'), true]
      options << [t('orders.sync.desync'), false]
      options_for_select options, selected_value
    end

    def customer_options_for_select_tecnics(customer, subsidiary, selected_value)
      tecnics = Order.where({customer_id: customer, subsidiary_id: subsidiary}).map{|x| x.tecnic_id}
      options = User.where(id: tecnics).order(:first_name).map{|x| ["#{x.first_name} #{x.last_name}", x.id]}
      options_for_select options, selected_value
    end

    def customer_options_for_select_city(customer, subsidiary, selected_value)
      cities = Order.where({customer_id: customer, subsidiary_id: subsidiary}).map{|x| x.city_id}
      options = City.where(id: cities).order(:name).map{|x| [x.name, x.id]}
      options_for_select options, selected_value
    end

    def customer_options_for_select_things(customer, selected_value)
      options =  Thing.where(user_id: customer).order(:name).map{|x| [x.name, x.id]}
      options.insert(0, ["Seleccione dispositivo...", 0])
      options_for_select options, selected_value
    end
  end
end
