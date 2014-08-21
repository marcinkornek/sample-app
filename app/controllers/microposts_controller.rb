class MicropostsController < ApplicationController
  before_action :signed_in_user,    only: [:create, :destroy]
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
    #   # this will be the name of the feed displayed on the feed reader
    # @title = "FEED title"

    # # the news items
    # # @feeds_items = current_user.feed.all.order("updated_at desc")
    # @feeds_items = Micropost.all

    # # this will be our Feed's update timestamp
    # @updated = @feeds_items.first.updated_at unless @feeds_items.empty?

    # respond_to do |format|
    #   format.atom { render :layout => false }

    # # we want the RSS feed to redirect permanently to the ATOM feed
    # format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
    @posts = Micropost.without_private_messages.all

    respond_to do |format|
      format.html {}
      format.atom { render layout: false }
    end
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
