class UsersController < ApplicationController
  before_action :user,                  only: [:edit, :update]
  before_action :signed_in_user,        only: [:edit, :update, :index,
                                               :followers, :following]
  before_action :redirect_to_root,      only: [:new, :create]
  before_action :correct_user,          only: [:edit, :update]
  before_action :not_allowed_as_user,   only: :destroy
  before_action :admin,                 only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_token
      @user.generate_rss_token
      # sign_in @user
      # flash[:success] = "Welcome to the Sample App!"
      flash[:notice] = "Check your email to confirm registration!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 30 )
    else
      @users = User.order(:id).paginate(page: params[:page], per_page: 30 ) #bez "per_page: 30" domyślnie jest 30
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.without_private_messages.paginate(page: params[:page], per_page: 20)
  end

  def edit
  end

  def update
    if @user.authenticate(params[:user][:password])
      if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
        # redirect_to edit_user_path(user)
      else
        render 'edit'
      end
    else

      @user.assign_attributes(user_params)
      # flash.now[:error] = 'Invalid password'
      @user.errors.add(:password, :invalid) #:invalid jest standardowym błędem, sa też inne
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to root_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page], per_page: 10)
    @users_all = @user.followed_users.all
    render :show_follow
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    @users_all = @user.followers.all
    render :show_follow
  end

  def rss
    @user = User.find_by(rss_token: params[:rss_token] )
    @rss_token = @user.rss_token
    @posts = @user.feed_without_user_posts
    @title = "#{@user.name} RSS"
    respond_to do |format|
      format.html {}
      format.atom { render layout: false }
    end
  end

  def activate_account
    @user = User.find_by!(activate_email_token: params[:token])
    if @user.activate_email_sent_at < 2.hours.ago
      redirect_to root_path
      flash[:alert] = "Activation email expired."
    else
      @user.verify
      redirect_to root_path
      flash[:success] = "Acount has been activated!"
    end
  end

#####################################################################

  private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

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

    def not_allowed_as_user
      unless current_user.admin?
        redirect_to(root_url)
      end
    end

    def admin
      if User.find(params[:id]).admin?
        redirect_to root_url
      end
    end

end
