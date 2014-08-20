class PasswordResetsController < ApplicationController
  def new
  end

  def send_password_reset

  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url
    flash[:notice] = "Email sent with password reset instructions."
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])
    p '-------------------'
    p session_params
    p '-------------------'
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path
      flash[:alert] = "Password reset has expired."

    elsif @user.update_attributes(session_params)
      redirect_to root_url
      flash[:notice] = "Password has been reset!"
    else
      render :edit
    end
  end

  ##########################################################

  private

  def session_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
