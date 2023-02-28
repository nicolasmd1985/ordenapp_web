class Users::CreateUsersFromCsv
  require 'csv'

  def initialize(csv_file, subsidiary_id, role, current_user)
    @csv_file = csv_file
    @subsidiary_id = subsidiary_id
    @role = role
    @city_id = current_user.city_id
    @corporation_id = current_user.corporation_id

  end

  def process
    users_count = 0
    user_saved = 0
    csv_text = File.read(@csv_file.path)
    csv = CSV.parse(csv_text, headers: true, col_sep: ',')

    csv.each do |component_array|
      document_number          = component_array[0]
      first_name               = component_array[1]
      last_name                = component_array[2]
      phone_number_1             = component_array[3]
      email                    = component_array[4]
      document_type            = component_array[5]
      company_name             = component_array[6]
      principal_activity       = component_array[7]
      priority_user            = component_array[8]
      web_page                 = component_array[9]

      params = {}
      params[:document_number]    = document_number.blank? ? "NA" : document_number
      params[:first_name]         = first_name.blank? ? "NA" : first_name
      params[:last_name]          = last_name.blank? ? "NA" : last_name
      params[:phone_number_1]       = phone_number_1.blank? ? "NA" : phone_number_1
      params[:email]              = email.blank? ? "NA" : email
      params[:document_type]      = document_type.blank? ? "NA" : document_type
      params[:company_name]       = company_name.blank? ? "NA" : company_name
      params[:principal_activity] = principal_activity.blank? ? "NA" : principal_activity
      params[:priority_user]      = priority_user.blank? ? "NA" : priority_user
      params[:web_page]           = web_page.blank? ? "NA" : web_page
      params[:role]               = @role
      params[:city_id]            = @city_id
      params[:subsidiary_id]      = @subsidiary_id.to_i
      params[:corporation_id]     = @corporation_id

      user_created, user = Users::CreateUser.new(params, params[:subsidiary_id]).process

      users_count += 1
      if user_created
        user_saved += 1
      end

    end

    return [users_count, user_saved]

  end

end
