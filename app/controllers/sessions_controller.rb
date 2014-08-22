class SessionsController < ApplicationController
before_action :email?,  only: [:create]
# before_action :check_email_confirmation, only: [:create]

  def new
    @user = User.new
  end

  def create
    if @user && @user.authenticate(params[:user][:password])
      if @user.verified?
        sign_in @user
        redirect_back_or @user
      else
        @user.errors.add(:base, :unverified, link: Rails.application.routes.url_helpers.reactivate_path(@user.id))
        render 'new'
      end
    else
      @user ||= User.new
      @user.errors.add(:base, :email_password) #:invalid jest standardowym błędem, sa też inne, niestandardowe błędy można samemu wpisać w en.yml
      render 'new'
    end
  end

  def destroy
    sign_out
    flash[:notice] = "You are signed out"
    redirect_to root_url
  end

  def reactivate_account
    @user = User.find(params[:id])
    @user.send_activation_token
    flash[:notice] = "Confirmation email has been send again!"
    render 'new'
  end

  ##########################################################################

  private

  # #before actions
  def email?
    m = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/.match(email)
    if m.nil?
      @user = User.find_by(username: email)
    else
      @user = User.find_by(email: email)
    end
  end

  def email
    params[:user][:email].downcase
  end

end
