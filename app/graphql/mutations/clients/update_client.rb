module Mutations
  module Clients
    class UpdateClient < BaseMutation
      argument :client_input, Inputs::UserInput, required: true

      field :client, Types::UserType, null: false
      field :errors, [String], null: false

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && (user.role == "admin" || user.role == "supervisor"))        
        client = User.find(args[:client_input][:id])  
        if client.update(args[:client_input].to_h)
          { client: client, errors: [] }
        else
          { client: nil, errors: client.errors.full_messages }
        end
      end
    end
  end
end
