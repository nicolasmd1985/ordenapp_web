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

    field :create_supervisor, mutation: Mutations::Supervisors::CreateSupervisor
    field :update_supervisor, mutation: Mutations::Supervisors::UpdateSupervisor

    field :create_client, mutation: Mutations::Clients::CreateClient
    field :update_client, mutation: Mutations::Clients::UpdateClient

    field :create_technician, mutation: Mutations::Technicians::CreateTechnician
    field :update_technician, mutation: Mutations::Technicians::UpdateTechnician
  end
end
