class MaintenaceThingJob < ApplicationJob
  queue_as :default

  def perform(thing)
    if thing.subsidiary.users.supervisor.count > 0
      supervisors =  thing.subsidiary.users.supervisor
      supervisors.each do |s|
        ThingNotifier.thing_maintenance_notification(s, nil, thing).deliver_now
      end
    else
      admin = User.find_by(corporaion_id: thing.subsidiary.corporation_id, role: "admin")
      ThingNotifier.thing_maintenance_notification(admin, nil, thing).deliver_now
    end
  end
end
