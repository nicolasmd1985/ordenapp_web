class CookiesController < ApplicationController
  def index
  end

  def policy
  end

  def consent
    # params[:consent] == true -> store in variable
    # should_we_track_everything = params[:consent] == true then yes
  end
end
