class HomeController < ApplicationController
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 12)
  end
end
