namespace :thing do
  desc "Notificar las tareas programadas para el dia siguiente."
  task :notify_thing => :environment do
    supervisors = User.where(role: '1')
    supervisors.each do |supervisor|
      orders = Order.where({supervisor_id: supervisor.id, status_id: [500, 501, 502]})
      things = Thing.where('DATE(maintenance_date) = ?', (Date.today + 1.days)).where({ order_id: [orders.ids]})
      ThingNotifier.thing_tomorrow_email(supervisor, orders, things).deliver
    end
  end
end
