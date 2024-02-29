module Mutations
  module Supervisors
    class UpdateSupervisor < BaseMutation      
      argument :supervisor_input, Inputs::UserInput, required: true

      field :supervisor, Types::UserType, null: false
      field :errors, [String], null: false

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")        
        supervisor = User.find(args[:supervisor_input][:id])  
        if supervisor.update(args[:supervisor_input].to_h)
          { supervisor: supervisor, errors: [] }
        else
          { supervisor: nil, errors: supervisor.errors.full_messages }
        end
      end
    end
  end
end
