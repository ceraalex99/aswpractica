class Api::ContributionsController < ApplicationController
  before_action :set_contribution, only: [:like, :unlike]


  def like
    @contribution.likes.create(user: current_api_user)
    @contribution.points += 1
    @contribution.save
    render json: nil, status: :ok
  end

  def unlike
    @contribution.likes.find_by(user: current_api_user).destroy
    @contribution.points -= 1
    @contribution.save
    render json: nil, status: :ok
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
