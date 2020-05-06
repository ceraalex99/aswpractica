class Api::ContributionsController < ApplicationController
  before_action :set_contribution, only: [:like, :unlike]
  skip_forgery_protection


  def like
    if (current_api_user.id != @contribution.user_id) && !(@contribution.likes.find_by(user: current_api_user))
      @contribution.likes.create(user: current_api_user)
      @contribution.points += 1
      @contribution.save 
      head :ok
    else 
      head :bad_request
    end
  end

  def unlike
    if @contribution.likes.find_by(user: current_api_user)
      @contribution.likes.find_by(user: current_api_user).destroy
      @contribution.points -= 1
      @contribution.save
      head :ok
    else
      head :bad_request
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contribution_params
    params.require(:contribution).permit(:title, :text, :url)
  end
end
