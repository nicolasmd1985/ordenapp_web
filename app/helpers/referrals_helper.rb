module ReferralsHelper
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

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

  def all_histories_for_referral(order)
    order.histories.where(origin: 'Mobile').order(created_at: :desc)
  end

end
