class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/user_submissions
  def user_submissions
    @id = params[:id]
    @posts = Post.all.where("user_id= ?", @id)
  end

  # GET /users/1/edit
  def edit
  end

  def logout
    cookies.delete(:user_id)
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    redirect_to callback
  end

  # POST /users
  # POST /users.json
  def create
    id_token = flash[:google_sign_in_token]
    if user = authenticate_with_google(id_token)
      cookies.signed[:user_id] = user.id
    else
      @user = User.new
      @user.name = GoogleSignIn::Identity.new(id_token).name
      @user.google_id = GoogleSignIn::Identity.new(id_token).user_id
      @user.save
      cookies.signed[:user_id] = @user.id
    end
    callback = cookies.signed[:callback]
    cookies.delete(:callback)
    redirect_to callback
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(@user)}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.likes.each do |like|
      @contribution = like.contribution
      @contribution.points -= 1
      @contribution.save
    end
    @user.likes.destroy_all
    @user.contributions.destroy_all
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private

    def authenticate_with_google(id_token)
      if id_token
        User.find_by_google_id(GoogleSignIn::Identity.new(id_token).user_id)
      elsif error = flash[:google_sign_in_error]
        logger.error "Google authentication error: #{error}"
        nil
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :about)
    end
end
