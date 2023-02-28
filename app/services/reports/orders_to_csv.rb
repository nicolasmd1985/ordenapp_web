class Reports::OrdersToCsv
  require 'csv'

  def initialize(orders)
    @orders = orders
  end

  def process
    CSV.generate do |csv|
      csv << ["internal_id", "customer_id_order", "created_at", "updated_at", "description",
              "city", "supervisor", "tecnic", "customer", "address", "status_id", "status",
              "substatus_id", "substatus", "install_date", "install_time", "limit_time",
              "category", "comment", "subsidiary", "sync", "origin"]

              @orders.each do |order|
                csv << [order.internal_id, order.customer_id_order, order.created_at.strftime("%Y-%m-%d %T"),
                        order.updated_at.strftime("%Y-%m-%d %T"), order.description, order.city.name,
                        "#{order.supervisor.try(:first_name)} #{order.supervisor.try(:last_name)}",
                        "#{order.tecnic.try(:first_name)} #{order.tecnic.try(:last_name)}",
                        "#{order.customer.try(:first_name)} #{order.customer.try(:last_name)}",
                        order.address, order.status_id, order.status.description,
                        order.try(:substatus_id), order.try(:substatus).try(:description), order.install_date,
                        order.install_time? ? order.install_time.strftime("%Y-%m-%d %T") : '',
                        order.limit_time? ? order.limit_time.strftime("%Y-%m-%d %T") : '',
                        order.try(:category).try(:name), order.comment,
                        order.try(:subsidiary).try(:name), order.sync, order.origin]
              end
    end
  end

end
