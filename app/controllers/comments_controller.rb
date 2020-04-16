class CommentsController < ApplicationController

  before_action :set_comment, only: [:show]

  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end
