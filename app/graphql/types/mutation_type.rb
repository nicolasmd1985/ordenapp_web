# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    # field :test_field, String, null: false,
    #   description: "An example field added by the generator"
    # def test_field
    #   "Hello World"
    # end

    field :sign_in, mutation: Mutations::SignIn
    field :sign_up, mutation: Mutations::SignUp
    field :update_admin_user, mutation: Mutations::UpdateAdminUser
    field :create_subsidiary, mutation: Mutations::Subsidiaries::CreateSubsidiary
    field :update_subsidiary, mutation: Mutations::Subsidiaries::UpdateSubsidiary
    field :delete_subsidiary, mutation: Mutations::Subsidiaries::DeleteSubsidiary
  end
end
