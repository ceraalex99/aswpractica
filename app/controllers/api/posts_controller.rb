class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    render json: @posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: @post
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:url, :tipo, :title, :text)
  end

  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end

