class Api::RepliesController < ApplicationController
  before_action :set_reply, only: [:show, :destroy, :replies]
  before_action :api_auth
  skip_forgery_protection

  def index
    @comment = Comment.find(params[:id])
    render json: @comment.replies.as_json(except: [:updated_at, :title, :url, :tipo], :methods => :author), status: :ok
  end

  def show
    render json: @reply.as_json(except: [:updated_at, :title, :url, :tipo], :methods => :author), status: :ok
  end

  def create
    @contribution = Contribution.find(reply_params[:contribution_id])
    @reply = @contribution.replies.create(reply_params)
    @reply.user = current_api_user
    @reply.post_id= @contribution.post_id
    if @reply.save
      render json: @reply.as_json(except: [:updated_at, :title, :url, :tipo], :methods => :author), status: :created
    else
      render json: @reply.errors, status: :bad_request
    end
  end

  def destroy
    if @reply.user_id == current_api_user.id
      @reply.likes.destroy_all
      @reply.destroy
      head :no_content
    else
      head :forbidden
    end
  end

  def replies
    @replies = @reply.replies
    render json: @replies.as_json(except: [:updated_at, :title, :url, :tipo], :methods => :author), status: :ok
  end

  private

  def set_reply
    @reply = Reply.find(params[:id])
  end

  def reply_params
    params.require(:reply).permit(:text, :post_id, :contribution_id)
  end
end