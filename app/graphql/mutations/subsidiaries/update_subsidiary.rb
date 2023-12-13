
module Mutations
  module Subsidiaries
    class UpdateSubsidiary < BaseMutation
      argument :subsidiary_input, Inputs::SubsidiaryInput, required: true

      field :subsidiary, Types::SubsidiaryType, null: false
      field :errors, [String], null: false

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")        
        subsidiary = user.corporation.subsidiaries.find(args[:subsidiary_input][:id])   
        if subsidiary.nil?
          return GraphQL::ExecutionError.new('Subsidiary not found.')
        end
        if subsidiary.update(args[:subsidiary_input].to_h)
          { subsidiary: subsidiary, errors: [] }
        else
          { subsidiary: nil, errors: subsidiary.errors.full_messages }
        end
      end
    end
  end
end
