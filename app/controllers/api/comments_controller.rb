class Api::CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :destroy, :replies]
  before_action :api_auth
  skip_forgery_protection

  def index
    @post = Post.find(params[:id])
    render json: @post.comments.as_json(except: [:contribution_id, :updated_at, :title, :url, :tipo], :methods => :author), status: :ok
  end

  def show
    render json: @comment.as_json(except: [:contribution_id, :updated_at, :title, :url, :tipo], :methods => :author), status: :ok
  end

  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user = current_api_user
    if @comment.save
      render json: @comment.as_json(except: [:contribution_id, :updated_at, :title, :url, :tipo], :methods => :author), status: :created
    else
      render json: @comment.errors, status: :bad_request
    end
  end

  def replies
    @replies = @comment.replies
    render json: @replies.as_json(except: [:updated_at, :title, :url, :tipo], :methods => :author), status: :ok
  end

  def destroy
    if @comment.user_id == current_api_user.id
      @comment.likes.destroy_all
      @comment.destroy
      head :no_content
    else
      head :forbidden
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end

end

