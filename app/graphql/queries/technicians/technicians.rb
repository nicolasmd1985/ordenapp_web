module Queries
  module Technicians
    class Technicians < Queries::BaseQuery
      argument :subsidiary_id, ID, required: true
      type [Types::UserType], null: false

      def resolve(subsidiary_id:)
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && (user.role == "admin" || user.role == "supervisor"))
        user.corporation.subsidiaries.find(subsidiary_id).users.where(role: "tecnic")
      end
    end
  end
end
