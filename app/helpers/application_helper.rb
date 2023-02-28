module ApplicationHelper
  include ActiveSupport::NumberHelper

  def substatus_desc_humanized(status)
    @status = status.to_s.gsub(/[\[\]]/, '')

    case @status
    when 'Warranty'
      t('orders.substatuses.warranty')
    when 'Service quality'
      t('orders.substatuses.serv_qua')
    when 'Cancelled'
      t('orders.substatuses.cancelled')
    when 'Absent customer'
      t('orders.substatuses.absent')
    when 'Canceled due non-compliance'
      t('orders.substatuses.non_comp')
    when 'Price quote pending'
      t('orders.substatuses.price_pend')
    when 'Pending by budget'
      t('orders.substatuses.budget')
    when 'Canceled by customer'
      t('orders.substatuses.canc_by_custo')
    when 'Authorization required'
      t('orders.substatuses.auth_requ')
    when 'Wrong data'
      t('orders.substatuses.wrong_data')
    when 'Product return'
      t('orders.substatuses.product_return')
    when 'Waiting customer contact'
      t('orders.substatuses.wait_cust_contact')
    when 'Prepaid'
      t('orders.substatuses.prepaid')
    when 'Paid'
      t('orders.substatuses.paid')
    when 'Delivered goods'
      t('orders.substatuses.deliv_goods')
    when 'Transfer to service center'
      t('orders.substatuses.transf')
    else
      @status
    end

  end

  def substatus_type_humanized(status)

    @status = status.to_s.gsub(/[\[\]]/, '')

    case @status
    when 'Done'
      t('orders.substatuses_type.done')
    when 'Pending'
      t('orders.substatuses_type.pending')
    when 'Receivable'
      t('orders.substatuses_type.receivable')
    when 'Service center'
      t('orders.substatuses_type.service_center')
    when 'in'
      t('things.status.in')
    when 'out'
      t('things.status.out')
    end
  end

  def options_for_select_order_status(selected_value)
    options = Status.where(type_status: 'order_status').order(:description).map{|x| [order_status_humanized(x.description), x.id]}
    options_for_select options, selected_value
  end

  def order_status_humanized(status)
    @status = status.to_s.gsub(/[\[\]]/, '')
    case @status
    when 'Request'
      t('orders.status.request')
    when 'Assigned'
      t('orders.status.assigned')
    when 'In Progress'
      t('orders.status.in_progress')
    when 'Rejected'
      t('orders.status.rejected')
    when 'Done'
      t('orders.status.done')
    when 'Pre_order'
      t('orders.status.pre_order')
    when 'Pending'
      t('orders.status.pending')
    when 'Receivable'
      t('orders.status.receivable')
    when 'Service center'
      t('orders.status.service_center')
    when 'Service evaluation'
      t('orders.status.service_evaluation')
    when 'Arrives place'
      t('orders.status.arrives_place')
    when 'Generated manual order'
      t('orders.status.manual_order')
    when 'No Progress'
      t('orders.status.no_progress')
    end
  end

  def parent_statuses_order
    @parent_statuses = Status.where(id: [504, 506, 507, 508]).map{|x| ["#{x.id} - #{substatus_type_humanized(x.description)}", x.id]}

  end

  def parent_statuses_thing
    @parent_statuses = Status.where(id: [300, 301]).map{|x| ["#{x.id} - #{substatus_type_humanized(x.description)}", x.id]}

  end

  def select_subsidiary_as_supervisor(current_user, selected_value)
    if current_user.role == "admin"
      options = Subsidiary.where(corporation_id: current_user.try(:corporation_id)).order(:name).map{|x| [x.name, x.id]}
      options.insert(0, [t('users.index.no_apply'), 0])
    else
      options = []
    end
    options_for_select options, selected_value
  end

  def select_qrcode_type
    options = []
    options << [t('category.types.tool'), "Tool"]
    options << [t('category.types.thing'), "Thing"]
    options << [t('category.types.component'), "Component"]
    options_for_select options
  end

  def distance_of_time_in_words_translation(from_time, to_time = Time.now, include_seconds = false, options = {})
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    I18n.with_options :locale => options[:locale], :scope => 'datetime.distance_in_words' do |locale|
      case distance_in_minutes
        when 0..1
          return distance_in_minutes == 0 ?
                 locale.t(:less_than_x_minutes, :count => 1) :
                 locale.t(:x_minutes, :count => distance_in_minutes) unless include_seconds

          case distance_in_seconds
            when 0..4   then locale.t :less_than_x_seconds, :count => 5
            when 5..9   then locale.t :less_than_x_seconds, :count => 10
            when 10..19 then locale.t :less_than_x_seconds, :count => 20
            when 20..39 then locale.t :half_a_minute
            when 40..59 then locale.t :less_than_x_minutes, :count => 1
            else             locale.t :x_minutes,           :count => 1
          end

        when 2..44           then locale.t :x_minutes,      :count => distance_in_minutes
        when 45..89          then locale.t :about_x_hours,  :count => 1
        when 90..1439        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
        when 1440..2529      then locale.t :x_days,         :count => 1
        when 2530..43199     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
        when 43200..86399    then locale.t :about_x_months, :count => 1
        when 86400..525599   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
        else
          distance_in_years           = distance_in_minutes / 525600
          minute_offset_for_leap_year = (distance_in_years / 4) * 1440
          remainder                   = ((distance_in_minutes - minute_offset_for_leap_year) % 525600)
          if remainder < 131400
            locale.t(:about_x_years,  :count => distance_in_years)
          elsif remainder < 394200
            locale.t(:over_x_years,   :count => distance_in_years)
          else
            locale.t(:almost_x_years, :count => distance_in_years + 1)
          end
      end
    end
  end
  # File actionpack/lib/action_view/helpers/date_helper.rb, line 115
  def time_ago_in_words_translation(from_time, include_seconds = false)
    distance_of_time_in_words_translation(from_time, Time.now, include_seconds)
  end
  alias distance_of_time_in_words_to_now_translation time_ago_in_words_translation


end
