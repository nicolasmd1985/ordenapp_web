module Queries
  module Subsidiaries
    class GetSubsidiary < BaseQuery
      description "Get subsidiary information"

      type Types::SubsidiaryType, null: false

      argument :id, ID, required: true

      def resolve(id:)
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")      
        user.corporation.subsidiaries.find(id)
      end
    end
  end
end
