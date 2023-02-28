class TokenExpirationWorker
  include Sidekiq::Worker

  def perform
    users = User.where.not(auth_token: nil)

    users.each do |user|
      begin
        JsonWebToken.decode(user.auth_token)

      rescue JWT::ExpiredSignature
        user.update_columns(status_id: 207, auth_token: nil)
      end 
    end
    
  rescue StandardError => e
    Rails.logger.debug(e.inspect)
  end
end
