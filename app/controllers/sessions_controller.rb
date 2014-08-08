class SessionsController < ApplicationController
before_action :email?,  only: [:create]
  def new

  end

  def create
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      redirect_back_or @user
    else
      flash.now[:error] = 'Invalid email/password or username/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
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
    params[:session][:email].downcase
  end

end
