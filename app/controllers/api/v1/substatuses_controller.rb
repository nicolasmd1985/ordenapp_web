class Api::V1::SubstatusesController < ApiController
  before_action :authorize_request, except: %i[done_substatuses pending_substatuses receivable_substatuses service_center_substatuses]

  def index
    done = Substatus.done(current_user.subsidiary_id)
    pending = Substatus.pending(current_user.subsidiary_id)
    receivable = Substatus.receivable(current_user.subsidiary_id)
    service = Substatus.service(current_user.subsidiary_id)

    @substatuses = done + pending + receivable + service

    render json: SubstatusDecorator.decorate(Substatus).substatuses_decorator(@substatuses), status: :ok
  end

  def done_substatuses
    @substatuses = Substatus.done(current_user.subsidiary_id)
    render json: SubstatusDecorator.decorate(Substatus).substatuses_decorator(@substatuses), status: :ok
  end

  def pending_substatuses
    @substatuses = Substatus.pending(current_user.subsidiary_id)
    render json: SubstatusDecorator.decorate(Substatus).substatuses_decorator(@substatuses), status: :ok
  end

  def receivable_substatuses
    @substatuses = Substatus.receivable(current_user.subsidiary_id)
    render json: SubstatusDecorator.decorate(Substatus).substatuses_decorator(@substatuses), status: :ok
  end

  def service_center_substatuses
    @substatuses = Substatus.service(current_user.subsidiary_id)
    render json: SubstatusDecorator.decorate(Substatus).substatuses_decorator(@substatuses), status: :ok
  end

end
