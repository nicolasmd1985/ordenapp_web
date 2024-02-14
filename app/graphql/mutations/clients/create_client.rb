
module Mutations
  module Clients
    class CreateClient < BaseMutation
      argument :client_input, Inputs::UserInput, required: true

      field :user, Types::UserType, null: true
      field :errors, [String], null: true

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && (user.role == "admin" || user.role == "supervisor"))
        client = User.new(args[:client_input].to_h)
        client.role = "customer"
        characters = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a + ('#?!@$%^&*-').chars
        length = 8
        password_tem = Array.new(length) { characters[rand(characters.length)].chr }.join
        client.password = password_tem
        client.active = true
        client.corporation_id = user.corporation_id
        client.status_id = 200        
        if client.save
          { user: client, errors: [] }
        else          
          { user: {} , errors: client.errors.full_messages }
        end
      end
    end
  end
end
