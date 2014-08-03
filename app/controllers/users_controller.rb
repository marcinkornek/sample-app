class UsersController < ApplicationController
  before_action :user,                  only: [:edit, :update]
  before_action :signed_in_user,        only: [:edit, :update, :index]
  before_action :redirect_to_root,      only: [:new, :create]
  before_action :correct_user,          only: [:edit, :update]
  before_action :not_allowed_as_admin,  only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.order(:id).paginate(page: params[:page], per_page: 30 ) #bez "per_page: 30" domyślnie jest 30
  end

   def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to root_url
  end

  private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        flash[:notice] = "Please sign in."
        redirect_to signin_url
      end
    end

    def redirect_to_root
      if signed_in?
        redirect_to root_url
      end
    end

    def correct_user
      unless current_user?(@user)
        @user = User.find(params[:id])
        redirect_to root_url
      end
    end

    def not_allowed_as_admin
      if current_user.admin?
        redirect_to(root_url)
      end
    end
end
