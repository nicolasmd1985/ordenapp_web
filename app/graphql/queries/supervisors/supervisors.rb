module Queries
  module Supervisors
    class Supervisors < Queries::BaseQuery
      type [Types::UserType], null: false

      def resolve()
        user = context[:current_user]            
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")      
        user.corporation.subsidiaries.map{|x| x.users }.flatten.map{|x| x if x.role == "supervisor"}.compact
      end
    end
  end
end
