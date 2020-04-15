class CommentsController < ApplicationController

  def index
    @comments = Comment.all
  end

  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end
