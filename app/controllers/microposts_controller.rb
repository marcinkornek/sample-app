class MicropostsController < ApplicationController
  before_action :signed_in_user,    only: [:create, :destroy, :show]
  before_action :correct_user,      only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  def index
    @posts = Micropost.without_private_messages.all

    respond_to do |format|
      format.html {}
      format.atom { render layout: false }
    end
  end

  def show
    @micropost = Micropost.without_private_messages.find(params[:id])
    @user = @micropost.user
  end

############################################################################

  private

    #before actions

    def micropost_params
      params.require(:micropost).permit(:content, :in_reply_to)
    end

    def correct_user
      @micropost = Micropost.find_by(id: params[:id])
      redirect_to root_url unless current_user?(@micropost.user)
    end

end
