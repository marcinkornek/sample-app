class PasswordResetsController < ApplicationController
  def new
  end

  def send_password_reset

  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reet if user
    redirect to root_url,
    flash[:notice] = "Email sent with password reset instructions."
  end

end
