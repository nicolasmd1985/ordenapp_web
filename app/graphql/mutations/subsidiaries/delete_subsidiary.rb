module Mutations
  module Subsidiaries
    class DeleteSubsidiary < BaseMutation
      argument :id, ID, required: true

      field :success, Boolean, null: false

      def resolve(id:)        
        subsidiary = Subsidiary.find(id)
        subsidiary.destroy
        { success: true }
      rescue ActiveRecord::RecordNotFound => e
        GraphQL::ExecutionError.new("Subsidiary with ID #{id} not found")
      rescue ActiveRecord::RecordNotDestroyed => e
        GraphQL::ExecutionError.new("Failed to delete subsidiary: #{e.message}")
      end
    end
  end
end
