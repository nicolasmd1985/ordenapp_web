module OrdersHelper
  require 'barby'
  require 'barby/barcode/code_128'
  # require 'barby/outputter/png_outputter'
  def br_image_tag(text)
    image_data = Barby::Code128.new(text).to_png(margin:3, height: 50)
    data_uri   = "data:image/png;base64,#{Base64.strict_encode64(image_data)}"
    image_tag(data_uri)
  end

  def br_image_uri(text)
    image_data = Barby::Code128.new(text).to_png(margin:10, height: 100, width: 100)
    data_uri   = "data:image/png;base64,#{Base64.strict_encode64(image_data)}"
    return data_uri
  end

  def options_for_select_order_sync(selected_value)
    options = []
    options << [t('orders.sync.sync'), true]
    options << [t('orders.sync.desync'), false]
    options_for_select options, selected_value
  end

  def options_for_select_order_customers(subsidiary, selected_value)
    options = User.where({subsidiary_id: subsidiary, role: 2}).order(:first_name).map{|x| ["#{x.first_name} #{x.last_name}", x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_customers_info(subsidiary, selected_value)
    options = User.where({subsidiary_id: subsidiary, role: 2}).order(:first_name).map{|x| ["#{x.first_name} #{x.last_name} - ID: #{x.document_number} - Tel: #{x.phone_number_1} - Empresa: #{x.company_name}", x.id]}
    options.insert(0, [t('orders.index.select_customer'), 0])
    options_for_select options, selected_value
  end

  def options_for_select_order_tecnics(subsidiary, selected_value)
    options = User.where({subsidiary_id: subsidiary, role: 0}).order(:first_name).map{|x| ["#{x.first_name} #{x.last_name}", x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_order_active_tecnics(subsidiary, selected_value)
    options = User.where({subsidiary_id: subsidiary, role: 0, active: true}).order(:first_name).map{|x| ["#{x.first_name} #{x.last_name}", x.id]}
    options.insert(0, [t('orders.index.select_tecnic'), 0])
    options_for_select options, selected_value
  end

  def options_for_select_order_city(subsidiary, selected_value)
    cities = User.where(subsidiary_id: subsidiary).map{|x| x.city_id}
    options = City.where(id: cities).order(:name).map{|x| [x.name, x.id]}
    options_for_select options, selected_value
  end

  def options_for_select_category(subsidiary, selected_value)
    options = Category.where(subsidiary_id: subsidiary).where(category_type: "Order")
    .or(Category.where(subsidiary_id: subsidiary).where(category_type: nil)).map{|x| [x.name, x.id]}
    # options.insert(0, [t('category.status.install'), 101])
    # options.insert(1, [t('category.status.maintenance'), 102])
    # options.insert(2, [t('category.status.repair'), 103])
    options_for_select options, selected_value
  end

  def customer_options_for_select_category(selected_value)
    options = []
    options.insert(0, [t('category.status.maintenance'), 102])
    options.insert(1, [t('category.status.install'), 101])
    options.insert(2, [t('category.status.repair'), 103])
    options_for_select options, selected_value
  end

  def category_humanized(status)
    @status = status.to_s.gsub(/[\[\]]/, '')
    case @status
    when 'install'
      t('category.status.install')
    when 'maintenance'
      t('category.status.maintenance')
    when 'repair'
      t('category.status.repair')
    end
  end

  def options_for_select_orders(subsidiary, selected_value)
    options =  Thing.where(subsidiary_id: subsidiary).order(:name).map{|x| [x.name, x.id]}
    # if selected_value.size >= 1
    #   selected_value.each do |selection|
    #     thing = Thing.find(selection)
    #     options.unshift([thing.name, thing.id])
    #   end
    # end
    options_for_select options, selected_value
  end

  def pretty_data_log(data_log)
    new_data = []
    date_fields = ["Limite", "Limit", "Hora instalación", "Install time"]

    data_log.each do |data|
      data_hash = {}
      data_hash[:field] = t("orders.logs.#{data[0]}")
      data_hash[:old_data] = data[1][0]
      data_hash[:new_data] = data[1][1]

      if (data_hash[:field] != "things_ids" && data_hash[:field] != "updated_at")
        data_hash[:old_data] = cast_log_dates(data_hash[:old_data]) if date_fields.include?(data_hash[:field])
        data_hash[:new_data] = cast_log_dates(data_hash[:new_data]) if date_fields.include?(data_hash[:field])
        new_data << data_hash
      end
    end
    new_data
  end

  def options_for_select_things(subsidiary, selected_value)
    options =  Thing.where(subsidiary_id: subsidiary).order(:name).map{|x| [x.name, x.id]}
    # if selected_value.size >= 1
    #   selected_value.each do |selection|
    #     thing = Thing.find(selection)
    #     options.unshift([thing.name, thing.id])
    #   end
    # end
    options_for_select options, selected_value
  end

  def all_histories_for_referral(order)
    order.histories.where(origin: 'Mobile').order(created_at: :desc)
  end

  def options_for_update_status(selected_value)
    options = []
    options.insert(0, [t('orders.index.select_status'), "0"])
    options.insert(1, [t('orders.status.rejected'), 503])
    options.insert(2, [t('orders.status.pending'), 506])
    options.insert(3, [t('orders.status.service_center'), 508])
    options.insert(4, [t('orders.status.receivable'), 507])

    options_for_select options, selected_value
  end

  def select_time_data(selected_value)
    options = [[t('orders.time.minute'), 'minutes'],
               [t('orders.time.hour'), 'hour'],
               [t('orders.time.day'), 'days']]

    options_for_select options, selected_value
  end

  def cast_install_date(install_date)
    install_date = install_date.split( )
    if install_date[0].to_i < 10
      install_date[0] = "0#{install_date[0]}" if install_date[0][0] != "0"
      casted_date = "#{install_date[0]} #{install_date[1]} #{install_date[2]} #{install_date[3]}"
    else
      casted_date = "#{install_date[0]} #{install_date[1]} #{install_date[2]} #{install_date[3]}"
    end
  end

  private
    def cast_log_dates(date)
      date.to_datetime.strftime("%Y-%m-%d %T") if !date.blank?
    end

end
