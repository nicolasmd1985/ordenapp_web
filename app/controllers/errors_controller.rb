class ErrorsController < ApplicationController
  protect_from_forgery with: :null_session

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: 'application'
  end

end
