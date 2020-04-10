class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy, :like, :unlike]

  before_action :require_login, only: [:new, :edit, :like, :create, :destroy, :like, :unlike]
  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.all.where("tipo = ?","url").order("points DESC")
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
  end

  # GET /contributions/new
  def new
    @contribution = Contribution.new
  end

  #GET /contributions/newest
  def newest
    @contributions = Contribution.all.order("created_at DESC")
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

  #GET /contributions/ask
  def ask
    @contributions = Contribution.all.where("tipo = ?","ask").order("points DESC")
  end


  # GET /contributions/:id/edit
  def edit

  end

  # POST /contributions
  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)
    @contribution.user = current_user
    callback = cookies.signed[:callback]
    cookies.delete(:callback)

    respond_to do |format|
      if @contribution.save
        @user = User.find(current_user.id)
        @user.karma += 1
        @user.save
        format.html { redirect_to callback}
        format.json { render :show, status: :created, location: @contribution }
      else
        format.html { render :new }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to callback}
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    respond_to do |format|
      format.html { redirect_to callback}
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
