module Queries
  module Subsidiaries
    class Subsidiaries < Queries::BaseQuery
      # argument :sort_direction, Types::Enums::SortDirection, required: false
      type [Types::SubsidiaryType], null: false

      def resolve()
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")      
        user.corporation.subsidiaries

      end
    end
  end
end
