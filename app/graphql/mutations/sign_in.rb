module Mutations
  class SignIn < Mutations::BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: true
    def resolve(email:, password:)
      user = User.find_by(email: email)
      if user&.valid_password?(password)
        token = JsonWebToken.encode(user_id: user.id)
        { token: token, user: user }
      else
        { errors: ["Invalid email or password"] }
      end
    end
  end
end