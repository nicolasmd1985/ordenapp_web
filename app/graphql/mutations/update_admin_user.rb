module Mutations
  class UpdateAdminUser < Mutations::BaseMutation

    argument :user_input, Inputs::UserInput, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: true
    
    def resolve(args)
      user = context[:current_user]            
      return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")   
      if user.update(args[:user_input].to_h)
        token = JsonWebToken.encode(user_id: user.id)
        { user: user }
      else
        { errors: ["Invalid email or password"] }
      end
    end
  end
end