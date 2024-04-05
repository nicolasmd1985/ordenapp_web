
module Mutations
  module Technicians
    class CreateTechnician < BaseMutation
      argument :technician_input, Inputs::UserInput, required: true

      field :technician, Types::UserType, null: true
      field :errors, [String], null: true

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")
        technician = User.new(args[:technician_input].to_h)
        technician.role = "tecnic"
        characters = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a + ('#?!@$%^&*-').chars
        length = 16
        password_tem = Array.new(length) { characters[rand(characters.length)].chr }.join
        technician.password = password_tem
        technician.active = true
        technician.corporation_id = user.corporation_id
        technician.status_id = 200        
        if technician.save
          { technician: technician, errors: [] }
        else          
          { technician: {} , errors: technician.errors.full_messages }
        end
      end
    end
  end
end
