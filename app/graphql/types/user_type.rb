module Types
  class UserType < Types::BaseObject
    field :id, ID, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :email, String, null: true
    field :corporation_id, String, null: true
    field :phone_number_1, String, null: true
    field :subsidiary, String, null: true
    def subsidiary
      object.subsidiary.name
    end
    field :subsidiary_id, ID, null: true
    def subsidiary_id
      object.subsidiary.id
    end
  end
end