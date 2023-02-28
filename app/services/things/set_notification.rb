class Things::SetNotification

  def initialize(thing, notification = 0)
    @thing = thing
    @notification = notification
  end

  def process
    mdate = @thing.maintenance_date
    if @thing.maintenance_time.present?
      t = @thing.maintenance_time.strftime('%T')
      tsec = Time.zone.parse(t).seconds_since_midnight.seconds
      mdate = mdate + tsec
    end
    if @notification == 1
      nt = @thing.notification
      ntimes = @thing.notification_time
      case ntimes
      when "minutes"
        mdate = mdate - nt.minutes
      when "hours"
        mdate = mdate - nt.hours
      when "days"
        mdate = mdate - nt.days
      when "weeks"
        mdate = mdate - nt.weaks
      end
    else
      mdate = mdate - 2.days
    end
    MaintenaceThingJob.set(wait_until: mdate).perform_later(@thing)
  end

end
