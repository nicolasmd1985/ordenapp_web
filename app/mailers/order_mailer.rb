class OrderMailer < ApplicationMailer

  def order_created_mail(order)
    @order = order
    @subsidiary = Subsidiary.find(@order.subsidiary_id)
    @tecnic = User.find(@order.tecnic_id)
    if @order.customer.email?
      mail(to: order.customer.email, subject:"Nueva orden para #{order.customer.first_name}")
    end
  end

  def self.order_finished(order)
    @order = order
    emails = [@order.supervisor.email, @order.customer.email, @order.tecnic.email]
    emails.each do |email|
      send_order_finished_mail(email, @order).deliver_later(wait: 1.minutes)
    end
  end

  def send_order_finished_mail(email, order)
    @order = order
    if !email.blank?
      id = @order.customer_id_order? ? @order.customer_id_order : @order.internal_id
      @referral = Referral.find_by(order_id: @order.id.to_s)
      @histories = History.where(order_id: @order.id)
      @order_type = category_humanized(@order.category.nil? ? "" : @order.category.name)
      @images = @order.histories.where(origin: 'Mobile').order(created_at: :desc)

      attachments["order_#{id}.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(:template => 'referrals/pdf/referralv2.pdf.haml')
      )
      mail(to: email, subject: "Orden #{id} finalizada")
    end
  end

  def order_created_tech_mail(order)
    @order = order
    @subsidiary = Subsidiary.find(@order.subsidiary_id)
    @tecnic = User.find(@order.tecnic_id)
    @customer = User.find(@order.customer_id)
    if @tecnic.email?
      mail(to: order.tecnic.email, subject:"Asignación orden #{order.internal_id}")
    end
  end

  def preorder_created_mail(order)
    @order = order
    @subsidiary = Subsidiary.find(@order.subsidiary_id)
    @user = "#{order.customer.first_name} #{order.customer.last_name}"
    @city = @order.city.name
    @thing = @order.try(:things) ? @order.try(:things).try(:first).try(:name) : 'NA'
    unless @subsidiary.email
      @subsidiary = User.where(subsidiary_id: @order.subsidiary_id).where(role: "supervisor").first
    end
    if @subsidiary.email?
      mail(to: @subsidiary.email, subject:"Nueva Pre-orden de #{@user}")
    end
  end

  def order_assigned_mail(order)
    @order = order
    @subsidiary = Subsidiary.find(@order.subsidiary_id)
    @tecnic = @order.tecnic
    if @order.customer.email?
      mail(to: @order.customer.email, subject:"La solicitud #{@order.internal_id} ha sido asignada")
    end
  end

  private
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

end
