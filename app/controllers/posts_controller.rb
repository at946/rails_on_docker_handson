class PostsController < ApplicationController
  before_action :redirect_to_root_unless_signed_in

  def index
    @post = Post.new
    # 更新日時降順で全てのポストを@postsに代入する
    @posts = Post.order(created_at: :desc)    
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    
    if @post.save
      redirect_to posts_path
    else
      # 更新日時降順で全てのポストを@postsに代入する
      @posts = Post.order(created_at: :desc)
      render :index
    end
  end

  private
    def post_params
      params.require(:post).permit(:content)
    end

    def redirect_to_root_unless_signed_in
      redirect_to root_path unless signed_in?
    end
end
