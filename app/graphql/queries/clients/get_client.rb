module Queries
  module Clients
    class GetClient < BaseQuery
      description "Get client information"

      type Types::UserType, null: false

      argument :client_id, ID, required: true

      def resolve(client_id:)
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")
        User.find(client_id)
      end
    end
  end
end
