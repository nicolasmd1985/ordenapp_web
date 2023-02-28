class Api::V2::SubstatusesController < ApiController
  before_action :authorize_request

  def index
    substatuses_in = Substatus.in(params[:subsidiary_id])
    substatuses_out = Substatus.out(params[:subsidiary_id])
    @substatuses = substatuses_in + substatuses_out
    render json: SubstatusDecorator.decorate(Substatus).substatuses_decorator(@substatuses), status: :ok
  end

end
