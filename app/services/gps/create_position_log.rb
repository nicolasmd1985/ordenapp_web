class Gps::CreatePositionLog

  def initialize(user, position = nil)
    @user = user
    @position = position
  end

  def process
    @log = Positions::PositionLog.new
    @log.name = @user.status.description
    @log.user = @user
    @log.position = @position

    if @log.save
      [true, @log]
    else
      [false, false]
    end
  end

end
