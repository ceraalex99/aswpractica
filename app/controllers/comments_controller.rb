class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:id])
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    redirect_to callback
  end


  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
