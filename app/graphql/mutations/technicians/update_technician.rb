module Mutations
  module Technicians
    class UpdateTechnician < BaseMutation      
      argument :technician_input, Inputs::UserInput, required: true

      field :technician, Types::UserType, null: false
      field :errors, [String], null: false

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && (user.role == "admin" || user.role == "supervisor"))        
        technician = User.find(args[:technician_input][:id])  
        if technician.update(args[:technician_input].to_h)
          { technician: technician, errors: [] }
        else
          { technician: nil, errors: technician.errors.full_messages }
        end
      end
    end
  end
end
