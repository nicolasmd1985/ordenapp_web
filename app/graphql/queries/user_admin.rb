module Queries
  class UserAdmin < Queries::BaseQuery
    # argument :sort_direction, Types::Enums::SortDirection, required: false
    type Types::UserType, null: false

    def resolve()
      user = context[:current_user]      
      return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")      
      user

    end
  end
end
