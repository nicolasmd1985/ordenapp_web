require "application_helper.rb"

class SubstatusDecorator < Draper::Decorator
  delegate_all

  def substatuses_decorator(substatuses)
    records = []
    substatuses.each do |substatus|
      records.push({
          id: substatus.id,
          description: substatus.description,
          substatus_type: substatus.substatus_type,
          subsidiary_id: substatus.subsidiary_id,
          status_id: substatus.status_id
        })
    end
    records
  end

  protected
    def substatus_desc_humanized(status)
      @status = status.to_s.gsub(/[\[\]]/, '')

      case @status
      when 'Warranty'
        I18n.t('orders.substatuses.warranty')
      when 'Service quality'
        I18n.t('orders.substatuses.serv_qua')
      when 'Cancelled'
        I18n.t('orders.substatuses.cancelled')
      when 'Absent customer'
        I18n.t('orders.substatuses.absent')
      when 'Canceled due non-compliance'
        I18n.t('orders.substatuses.non_comp')
      when 'Price quote pending'
        I18n.t('orders.substatuses.price_pend')
      when 'Pending by budget'
        I18n.t('orders.substatuses.budget')
      when 'Canceled by customer'
        I18n.t('orders.substatuses.canc_by_custo')
      when 'Authorization required'
        I18n.t('orders.substatuses.auth_requ')
      when 'Wrong data'
        I18n.t('orders.substatuses.wrong_data')
      when 'Product return'
        I18n.t('orders.substatuses.product_return')
      when 'Waiting customer contact'
        I18n.t('orders.substatuses.wait_cust_contact')
      when 'Prepaid'
        I18n.t('orders.substatuses.prepaid')
      when 'Paid'
        I18n.t('orders.substatuses.paid')
      when 'Delivered goods'
        I18n.t('orders.substatuses.deliv_goods')
      when 'Transfer to service center'
        I18n.t('orders.substatuses.transf')
      else
        @status
      end

    end

end
