module Types
  class SubsidiaryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :phone, String, null: false
    field :address, String, null: false
    field :email, String, null: false
    field :subsidiary_initials, String, null: false
    field :corporation, Types::CorporationType, null: false

  end
end