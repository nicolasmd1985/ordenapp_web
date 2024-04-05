module Queries
  module Technicians
    class GetTechnician < BaseQuery
      description "Get Technician information"

      type Types::UserType, null: false

      argument :technician_id, ID, required: true

      def resolve(technician_id:)
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && (user.role == "admin" || user.role == "supervisor"))
        User.find(technician_id)
      end
    end
  end
end
