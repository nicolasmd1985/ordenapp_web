class UsersController < ApplicationController
  require 'csv'
  before_action :authenticate_user!, except: [:cities]
  before_action :allow_create_user, except: [:index, :active]
  before_action :supervisor?, only: [:index, :active]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :active]

  rescue_from ActiveRecord::RecordNotFound do |error|
    redirect_to dashboard_url, notice: "User not found"
  end

  # before_create :set_auth_token
  def index

    if (params[:search].present? && !params[:search].blank?) || (params[:city].present? && !params[:city].blank?)
      @users = User.search(current_user.subsidiary_id, params[:role], params[:search], params[:city])
    else
      @users = User.users_colaborators(current_user.subsidiary_id, params[:role])
    end
    @role = params[:role]
    @city = params[:city].present? ? params[:city] : ''
    case params[:role]
    when "0"
      add_breadcrumb "#{t("base.bar_menu.tecnics.tecnics")}/#{t("base.bar_menu.tecnics.list")}"
    when "1"
      add_breadcrumb "#{t("base.bar_menu.admins.supervisor")}/#{t("base.bar_menu.admins.list")}"
    when "2"
      add_breadcrumb "#{t("base.bar_menu.customers.customers")}/#{ t("base.bar_menu.customers.list")}"
    end
  end

  def show
    if @user.subsidiary_id == current_user.subsidiary_id ||  @user.corporation_id == current_user.corporation_id
      @orders = Order.orders_tecnic(params[:id])
    else
      redirect_to dashboard_url, notice: "This user is not registered in your subsidiary"
    end
  end

  def new
    if current_user.role == "admin" && params[:role] == "3"
      redirect_to admins_users_url, alert: "Unauthorized params."
    elsif current_user.role == "supervisor" && (params[:role] == "1" || params[:role] == "3")
      redirect_to users_url(role: 0), alert: "Unauthorized params."
    end
    @user = User.new
    @user.role = params[:role].to_i if params[:role]
    case params[:role]
    when "0"
      add_breadcrumb "#{t("base.bar_menu.tecnics.tecnics")}/#{t("base.bar_menu.tecnics.new")}"
    when "1"
      add_breadcrumb "#{t("base.bar_menu.admins.supervisor")}/#{t("base.bar_menu.admins.new_s")}"
    when "2"
      add_breadcrumb "#{t("base.bar_menu.customers.customers")}/#{t("base.bar_menu.customers.new")}"
    end
  end

  def edit

    if @user.subsidiary_id == current_user.try(:subsidiary_id) ||  @user.corporation_id == current_user.corporation_id
    city = City.find(@user.city_id)
    city_name = city.name
    country = Country.find(city.country_id)
    country_name = country.name
    @city_name = "#{city_name}, #{country_name}"
    @place_id = city.place_id
    @country_id = country.place_id

    else
      redirect_to dashboard_url, notice: "This user is not registered in your subsidiary"
    end
  end

  def create
    @user = User.new(user_params)
    @user.active = true
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def cities
    if params[:placeid].present?
      placeid = params[:placeid]
      @result = Net::HTTP.get(URI.parse("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{placeid}&inputtype=textquery&fields=place_id&key=#{ENV['GOOGLE_MAPS_API_SERVER_KEY']}"))
      render json: @result, status: :ok
    end
    if params[:city].present?
      city = params[:city]
      @result = Net::HTTP.get(URI.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=#{city}&types=(cities)&key=#{ENV['GOOGLE_MAPS_API_SERVER_KEY']}"))
      render json: @result, status: :ok
    end
  end

  def update
    @user.status_id = 200
    old_email = @user.email
    cityId = Users::CreateCity.new(params[:user][:city_value], params[:user][:place_id], params[:user][:country_id]).create
    @user.update(city_id: cityId)
    if @user.update(user_params)
      if old_email.blank? && !params[:user][:email].blank?
        password_tem = Users::PasswordGenerator.generate
        @user.update_attributes(password: password_tem)
        TecnicMailer.welcome_mail(@user, password_tem).deliver_later(wait: 1.minute) if @user.role == "tecnic"
        CustomerMailer.welcome_mail(@user, password_tem).deliver_later(wait: 1.minute) if @user.role == "customer"
      end
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end


  end

  def active
    @order = User.active_orders(@user.id, @user.subsidiary_id)
    if @order < 1
      if @user.active == true
        @user.active = false
      else
        @user.active = true
      end
      if @user.save
        redirect_to users_url(:role => 0), notice: "User #{(@user.active == true) ? "actived." : "Inactived."}"
      else
        redirect_to users_url(:role => 0), alert: "An error has ocurred."
      end
    else
      redirect_to users_url(:role => 0), alert: "There are open orders, imposible to inactive this user."
    end
  end

  def import_csv_form
    @role = params[:role]
    session[:passed_variable] = @role
    case params[:role]
    when "0"
      add_breadcrumb "#{t("base.bar_menu.tecnics.tecnics")}/#{t("base.bar_menu.tecnics.upload")}"
    when "1"
      add_breadcrumb "#{t("base.bar_menu.admins.supervisor")}/#{t("base.bar_menu.admins.upload")}"
    when "2"
      add_breadcrumb "#{t("base.bar_menu.customers.customers")}/#{t("base.bar_menu.customers.upload")}"
    end
  end

  def import_csv
    csv_file = params[:csv_file]
    @role = session[:passed_variable]
    @get_value = @role

    if csv_file.present? && File.extname(csv_file.original_filename) == ".csv"
      users_loaded, saved = Users::CreateUsersFromCSV.new(csv_file, current_user.subsidiary_id, @role, current_user).process
      redirect_to dashboard_url, notice: t('users.import.success', saved: saved, users_loaded: users_loaded)
    else
      redirect_to users_import_csv_form_url, alert: "An error has ocurred. Verify extention file."
    end
  end

  def download_csv
    layout =  CSV.generate do |csv|
                csv << [t('users.index.document_number'),t('users.index.name'), t('users.index.last_name'), t('users.index.phone'), t('users.index.email'), t('users.index.document_type'), t('users.index.company_name'), t('users.index.principal_activity'), t('users.index.priority_user'), t('users.index.web_page')]
              end
    respond_to do |format|
      format.csv { send_data layout, filename: "upload-users-#{Date.today}.csv" }
    end
  end

  def as_supervisor
    if current_user.role == "admin"
      user = current_user

      if params[:subsidiary_id] == "0"
        # user.update_attributes(as_supervisor: false, subsidiary_id: nil)
        user.as_supervisor = false
        user.subsidiary_id = nil
        user.save(validate: false)
        redirect_to admins_subsidiaries_url, notice: "Now you are acting as admin."
      else
        # user.update_attributes(as_supervisor: true, subsidiary_id: params[:subsidiary_id])
        user.as_supervisor = true
        user.subsidiary_id = params[:subsidiary_id]
        if user.save(validate: false)
          redirect_to dashboard_url, notice: "Now you are acting as supervisor for #{current_user.try(:subsidiary).try(:name)}."
        else
          redirect_to edit_user_registration_url, notice: "Update your account to manage subsidiaries."
        end
      end

    else
      redirect_to root_url, alert: "Unauthorized"
    end
  end

  private
    def set_auth_token
      return if auth_token.present?
      self.auth_token = generate_auth_token
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/,'')
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      case @user.role
      when "tecnic"
        add_breadcrumb "#{t("base.bar_menu.tecnics.tecnics")}"
      when "supervisor"
        add_breadcrumb "#{t("base.bar_menu.admins.supervisor")}"
      when "customer"
        add_breadcrumb "#{("base.bar_menu.customers.customers")}"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:web_page, :priority_user, :principal_activity, :company_name, :document_type, :document_number, :first_name, :last_name, :email, :phone_number_1, :phone_number_2, :address_1, :address_2, :subsidiary_id, :role, :status_id, :active, :city_id, :urlavatar)
    end

end
