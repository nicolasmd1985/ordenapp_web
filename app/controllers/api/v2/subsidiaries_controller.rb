class Api::V2::SubsidiariesController < ApiController
  before_action :authorize_request

  def index
    if current_user.role == "admin"
      @subsidiaries = Subsidiary.where(corporation_id: current_user.try(:corporation_id))
      if @subsidiaries
        @subsidiaries_json = []
        @subsidiaries.each do |o|
          @subsidiaries_json << {
            "id_subsidiary" => o.id,
            "name" => o.name
          }
        end
        render json: @subsidiaries_json, status: :ok
      else
        render json: { errors: @subsidiaries.errors.full_messages },
               status: :unprocessable_entity
      end
    else
      @subsidiaries = current_user.subsidiary
      @subsidiaries_json = []
      @subsidiaries_json << {
        "id_subsidiary" => @subsidiaries.id,
        "name" => @subsidiaries.name
      }
      render json: @subsidiaries_json, status: :ok
    end
  end

end
