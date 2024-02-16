module Queries
  module Supervisors
    class GetSupervisor < BaseQuery
      description "Get supervisor information"

      type Types::UserType, null: false

      argument :supervisor_id, ID, required: true

      def resolve(supervisor_id:)
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")
        User.find(supervisor_id)
      end
    end
  end
end
