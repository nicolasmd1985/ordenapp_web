module Mutations
  class SignUp < Mutations::BaseMutation
    argument :user, Inputs::UserInput , required: true
    argument :corporation_name, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: true

    def resolve(user:, password:, corporation_name:)
      check_mail = User.find_by(email: user.email)
      check_corporation = Corporation.find_by(name: user.corporation_id)
      if check_corporation.nil? && check_mail.nil?

        corporation = Users::CreateCorporation.new(corporation_name)        
        corporation_id = corporation.process
        if corporation_id
          user = User.new(user.to_hash)
          user.password = password
          user.corporation_id = corporation_id
          user.role = 3
          user.status_id = 200
          user.active = true
          user.document_type = "OTRO"
          user.save!(validate: false)
          token = JsonWebToken.encode(user_id: user.id)
          # Se incluye el envio de mail bienvenida al admin que ha creado la Compañia
          AdminMailer.welcome_mail(@user, password).deliver_later
          { token: token, user: user }
        else
          Corporation.find_by(corporation_id).delete
          { errors: ["Error creating user"] }
        end
      else
        error_create(check_mail, check_corporation)
      end

    end
    protected
    def error_create(check_mail, check_corporation)
      msg_email = "El correo eléctronico #{check_mail.email} ya se encuentra registrado." if !check_mail.blank?
      msg_corporation = "La compañia #{check_corporation.name} ya se encuentra registrada." if !check_corporation.blank?
      { errors: ["#{msg_email} #{msg_corporation}"] }
      # redirect_to new_user_registration_url, alert:"#{msg_email} #{msg_corporation}"
    end
  
  end
end