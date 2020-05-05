class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy, :like, :unlike]

  before_action :require_login, only: [:new, :edit, :like, :create, :destroy, :like, :unlike]

  # GET /contributions/1
  # GET /contributions/1.json
  def show
  end


  def like
    @contribution.likes.create(user: current_user)
    @contribution.points += 1
    @contribution.save
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    redirect_to callback
  end

  def unlike
    @contribution.likes.find_by(user: current_user).destroy
    @contribution.points -= 1
    @contribution.save
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    redirect_to callback
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.likes.destroy_all

    @contribution.destroy

    respond_to do |format|
      format.html { redirect_to root_path}
      format.json { head :no_content }
    end
  end

  private
  def require_login
    unless current_user
      repost('/google_sign_in/authorization',
             params: { proceed_to: '/login' },
             options: { authenticity_token: :auto })

    end
  end
    # Use callbacks to share common setup or constraints between actions.
  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def contribution_params
    params.require(:contribution).permit(:title, :text, :url)
  end
end
