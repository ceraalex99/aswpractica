class InteractionsController < ApplicationController

  before_action :set_interaction, only: [:show]

  before_action :require_login, only: [:reply]

  def show
    @reply = Reply.new
  end

  def reply
    @contribution = Contribution.find(params[:reply][:contribution_id])
    @reply = @contribution.replies.create(reply_params)
    @reply.user = current_user
    @reply.post_id = @contribution.post_id
    @reply.valid?
    logger.debug @reply.errors.messages
    @reply.save

    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    redirect_to callback
  end

  private

  def require_login
    unless current_user
      repost('/google_sign_in/authorization',
             params: { proceed_to: '/login' },
             options: { authenticity_token: :auto })

    end
  end

  def set_interaction
    @interaction = Contribution.find(params[:id])
  end
  
  def reply_params
    params.require(:reply).permit(:text, :contribution_id)
  end

end
