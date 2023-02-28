class ReportsController < ApplicationController
  require 'csv'

  before_action :authenticate_user!
  before_action :supervisor?

  def orders
    add_breadcrumb "#{t('reports.reports')}/#{t('reports.orders')}"

    if (params[:search].present? && !params[:search].blank?) ||
      (params[:sync].present? && !params[:sync].blank?) ||
      (params[:status].present? && !params[:status].blank?) ||
      (params[:customer].present? && !params[:customer].blank?) ||
      (params[:tecnic].present? && !params[:tecnic].blank?) ||
      (params[:city].present? && !params[:city].blank?) ||
      (params[:from_date].present? && !params[:from_date].blank?) ||
      (params[:to_date].present? && !params[:to_date].blank?)
      @orders = Order.search(current_user.subsidiary_id,
                             params[:search], params[:sync],
                             params[:status], params[:customer],
                             params[:tecnic], params[:city])

      @orders = Reports::FilterReport.new(@orders, params).process if params[:from_date].present? && !params[:from_date].blank?
    else
      @orders = Order.where(subsidiary_id: current_user.subsidiary_id).order(created_at: :desc).limit(20)
    end

    @sync = params[:sync].present? ? params[:sync] : ''
    @status_p = params[:status].present? ? params[:status] : ''
    @customer = params[:customer].present? ? params[:customer] : ''
    @tecnic = params[:tecnic].present? ? params[:tecnic] : ''
    @city = params[:city].present? ? params[:city] : ''
    @from_date = params[:from_date].present? ? params[:from_date] : ''
    @to_date = params[:to_date].present? ? params[:to_date] : Date.today.strftime("%Y-%m-%d")
  end

  def orders_to_csv
    if (params[:search].present? && !params[:search].blank?) ||
      (params[:sync].present? && !params[:sync].blank?) ||
      (params[:status].present? && !params[:status].blank?) ||
      (params[:customer].present? && !params[:customer].blank?) ||
      (params[:tecnic].present? && !params[:tecnic].blank?) ||
      (params[:city].present? && !params[:city].blank?) ||
      (params[:from_date].present? && !params[:from_date].blank?) ||
      (params[:to_date].present? && !params[:to_date].blank?)
      @orders = Order.search(current_user.subsidiary_id,
                             params[:search], params[:sync],
                             params[:status], params[:customer],
                             params[:tecnic], params[:city])

      @orders = Reports::FilterReport.new(@orders, params).process if params[:from_date].present? && !params[:from_date].blank?

      @orders_csv = Reports::OrdersToCsv.new(@orders).process

      respond_to do |format|
        format.csv {
          send_data @orders_csv, filename: "orders-reports-#{Time.now.strftime("%Y-%m-%d %T")}.csv"
        }

        format.xlsx {
          send_data @orders.to_xlsx.to_stream.read, :filename => "orders-reports-#{Time.now.strftime("%Y-%m-%d %T")}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }
        end
    else

    end
  end

end
