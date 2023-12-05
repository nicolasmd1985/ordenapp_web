module Types
  class SubsidiaryType < Types::BaseObject
    field :id, ID, null: true
    field :name, String, null: true
    field :phone, String, null: true
    field :address, String, null: true
    field :email, String, null: true
    field :subsidiary_initials, String, null: true
    field :corporation, Types::CorporationType, null: true

  end
end