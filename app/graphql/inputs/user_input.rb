module Inputs
  class UserInput < Types::BaseInputObject
    argument :id, ID, required: false
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :email, String, required: false
    argument :corporation_id, String, required: false
  end
end
