
module Mutations
  module Supervisors
    class CreateSupervisor < BaseMutation
      argument :supervisor_input, Inputs::UserInput, required: true

      field :user, Types::UserType, null: true
      field :errors, [String], null: true

      def resolve(args)
        user = context[:current_user]
        return GraphQL::ExecutionError.new('Unauthorized for the action.') unless (user.present? && user.role == "admin")
        supervisor = User.new(args[:supervisor_input].to_h)
        supervisor.role = "supervisor"
        characters = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a + ('#?!@$%^&*-').chars
        length = 16
        password_tem = Array.new(length) { characters[rand(characters.length)].chr }.join
        supervisor.password = password_tem
        supervisor.active = true
        supervisor.corporation_id = user.corporation_id
        supervisor.status_id = 200        
        if supervisor.save
          { user: supervisor, errors: [] }
        else          
          { user: {} , errors: supervisor.errors.full_messages }
        end
      end
    end
  end
end
