module Inputs
  class SubsidiaryInput < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: false
    argument :phone, String, required: false
    argument :address, String, required: false
    argument :email, String, required: false
    argument :corporation_id, String, required: false

  end
end
