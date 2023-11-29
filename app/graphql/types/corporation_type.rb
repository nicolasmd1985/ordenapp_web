module Types
  class CorporationType < GraphQL::Schema::Object
    field :id, ID, null: false
    field :name, String, null: true
    field :address, String, null: true
    field :phone, String, null: true
    field :email, String, null: true
  
  end  
end
