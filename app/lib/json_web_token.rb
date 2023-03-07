class JsonWebToken
  SECRET_KEY = 'd82c2610bbd069ccd3050397861da48cdc2569f40084b565326fb44825ff94d2a2c611f98e6289c16869b961ccc7733bcedb39ac554488bf80d6bea7bfeebd4c'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
