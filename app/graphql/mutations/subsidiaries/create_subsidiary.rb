
module Mutations
  module Subsidiaries
    class CreateSubsidiary < BaseMutation
      argument :subsidiary_input, Inputs::SubsidiaryInput, required: true

      field :subsidiary, Types::SubsidiaryType, null: false
      field :errors, [String], null: false

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")

        subsidiary = Subsidiary.new(args[:subsidiary_input].to_h)
        subsidiary.status_id = 100
        subsidiary.corporation_id = user.corporation.id        

        if subsidiary.save
          { subsidiary: subsidiary, errors: [] }
        else
          { subsidiary: nil, errors: subsidiary.errors.full_messages }
        end
      end
    end
  end
end
