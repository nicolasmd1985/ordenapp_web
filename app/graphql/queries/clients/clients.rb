module Queries
  module Clients
    class Clients < Queries::BaseQuery
      argument :subsidiary_id, ID, required: true
      type [Types::UserType], null: false

      def resolve(subsidiary_id:)
        user = context[:current_user]       
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && (user.role == "admin" || user.role == "supervisor"))
        user.corporation.subsidiaries.find(subsidiary_id).users.where(role: "customer")
      end
    end
  end
end
