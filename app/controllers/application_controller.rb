class ApplicationController < ActionController::Base
	before_action :setting_locale
	before_action :users_tecnics_and_customers
	before_action :orders_count, :unread_notifications, if: -> { user_signed_in? }

	def dashboard
	end

	def setting_locale
		if request.format.html?
			if params[:locale].present?
				I18n.locale = params[:locale]
			else
				I18n.locale = params[:locale]
				# switch_locale
			end
		end
	end

	protected

	def after_sign_up_path_for(resource)
	  stored_location_for(resource) || dashboard_path
	end

	def after_sign_in_path_for(resource)
	  stored_location_for(resource) || dashboard_path
	end


	private

	#user must be a supervisor
	def orders_count
		@count = Notification.counted(current_user)
	end

	def unread_notifications
		@unread = Notification.unread(current_user)
	end

	# def switch_locale
	# 	country = Geocoder.search(request.remote_ip).first.country
	# 	countries = ['CO', 'BO','CL','CR', 'CU', 'EC', 'ES', 'GT', 'HN', 'MX', 'PA', 'PE', 'PR', 'SV', 'UY','VE']
	# 	if !country.nil?
	# 		if countries.include? country
	# 			I18n.locale = :es
	# 			params[:locale] = "es"
	# 		else
	# 			I18n.locale = :en
	# 			params[:locale] = "en"
	# 		end
	# 	elsif !locale.nil?
	# 		I18n.locale = locale
	# 		params[:locale] = locale
	# 	end
	# end


	def users_tecnics_and_customers
		if request.format.json? && current_user
			@users_tecnics = User.users_count(current_user.subsidiary_id, 0)
			@users_customers = User.users_count(current_user.subsidiary_id, 2)
		elsif request.format.html? && user_signed_in?
			@users_tecnics = User.users_count(current_user.subsidiary_id, 0)
			@users_customers = User.users_count(current_user.subsidiary_id, 2)
		end
	end

	# def default_url_options(options = {})
	# 	 results = Geocoder.search(request.remote_ip)
	# 	 unless results.nil? || results == 0
	# 	 		country_local = results.first.country
	#  	 end
	# 	 if country_local == "CO"
	#   	{locale: :es}
	# 	else
	# 		{locale: :en}
	# 	end
	# end

	def superadmin?
		if user_signed_in?
			if current_user.role == "superadmin"

			else
				url = current_user.role == "supervisor" ? dashboard_url : customers_dashboard_url

				redirect_to url, notice:'The request page is not defined.'
			end
		end
	end

	def supervisor?
		if user_signed_in?
			case current_user.role
			when 'admin'
				# redirect_to admins_subsidiaries_path, notice:'The request page is not defined.'
			when 'supervisor'

			when 'customer'
				redirect_to customers_dashboard_url, notice:'The request page is not defined.'
			when 'tecnic'
				redirect_to edit_user_registration_path, notice:'The request page is not defined.'
			end
		end
	end

	def customer?
		if user_signed_in?
			case current_user.role
			when 'admin'
				redirect_to admins_subsidiaries_path, notice:'The request page is not defined.'
			when 'supervisor'
				redirect_to dashboard_url, notice:'The request page is not defined.'
			when 'customer'

			when 'tecnic'
				redirect_to edit_user_registration_path, notice:'The request page is not defined.'
			end
		end
	end

	def admin?
		if user_signed_in?
			case current_user.role
			when 'admin'

			when 'supervisor'
				redirect_to dashboard_url, notice:'The request page is not defined.'
			when 'customer'
				redirect_to customers_dashboard_url, notice:'The request page is not defined.'
			when 'tecnic'
				redirect_to edit_user_registration_path, notice:'The request page is not defined.'
			end
		end
	end

	def allow_create_user
		if user_signed_in?
			case current_user.role
			when 'admin'

			when 'supervisor'

			when 'customer'
				redirect_to customers_dashboard_url, notice:'The request page is not defined.'
			when 'tecnic'
				redirect_to edit_user_registration_path, notice:'The request page is not defined.'
			end
		end
	end

end
