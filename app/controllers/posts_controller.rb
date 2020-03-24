class PostsController < ApplicationController
  def index
    redirect_to root_path unless signed_in?
    @post = Post.new
  end
end
