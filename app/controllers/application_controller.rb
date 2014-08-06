class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper


  helper_method :signed_in_user
  def signed_in_user
    unless signed_in?
      store_location
      flash[:notice] = "Please sign in."
      redirect_to signin_url
    end
  end
end
