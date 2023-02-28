class Api::V1::UsersController < ApiController
	before_action :authorize_request, except: [:create, :index]
	before_action :find_user, except: %i[create index customers]


	  # GET /users
	  def index
	    @users = User.all
	    render json: @users, status: :ok
	  end

	  # GET /users/{username}
	  def show
	    render json: @user, status: :ok
	  end

	  # POST /users
	  def create
	    @user = User.new(user_params)
			characters = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a + ('#?!@$%^&*-').chars
      length = 16
      password_tem = Array.new(length) { characters[rand(characters.length)].chr }.join
      @user.password = password_tem
			@user.role = 2
			@user.active = true
      @user.subsidiary_id = current_user.subsidiary_id
      @user.status_id = 200
	    if @user.save
				CustomerMailer.welcome_mail(@user, password_tem).deliver_later(wait: 1.minute)
	      render json: @user, status: :created
	    else
	      render json: { errors: @user.errors.full_messages },
	             status: :unprocessable_entity
	    end
	  end

	  # PUT /users/{username}
	  def update
	    unless @user.update(user_params)
	      render json: { errors: @user.errors.full_messages },
	             status: :unprocessable_entity
	    end
	  end

	  # DELETE /users/{username}
	  def destroy
	    @user.destroy
	  end

		def customers
			@names = []
			subsidiary = params[:subsidiary_id].present? ? params[:subsidiary_id] : current_user.subsidiary_id
			customers = User.users_colaborators(subsidiary, 2)
			customers.each do |n|
			  @names << {
					"customer_id" => n.id,
					"first_name" => n.first_name.to_s,
					"last_name" => n.last_name.to_s,
					"email" => n.email.to_s,
					"phone_number_1" => n.phone_number_1.to_s,
					"city" => n.city.name.to_s,
					"subsidiary_id" => n.subsidiary_id
				}
			end
			render json: @names


		end

	  private

	  def find_user
	    @user = User.find(params[:id])
	    rescue ActiveRecord::RecordNotFound
	      render json: { errors: 'User not found' }, status: :not_found
	  end

	  def user_params
	    params.permit(
	      :first_name, :email, :password, :password_confirmation, :status_id
	    )
	  end
	end
