class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :api_auth
  skip_forgery_protection

  # GET /users/1
  # GET /users/1.json
  def show
    if current_api_user.id == @user.id
      render json: @user.as_json(except: [:updated_at])
    else
      render json: @user.as_json(except: [:google_id, :updated_at])
    end
  end

  # GET /users/1/submissions
  def submissions
    @id = params[:id]
    @posts = Post.all.where("user_id= ?", @id)
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author)
  end

  # GET /users/1/comments
  def comments
    @id = params[:id]
    @comments = Comment.all.where("user_id = ?", @id) + Reply.all.where("user_id = ?", @id)
    render json: @comments.as_json(only: [:type, :id, :text, :user_id, :points, :created_at, :post_id, :contribution_id], :methods => :author), status: :ok
  end

  # GET /users/1/upvoted_submissions
  def upvoted_submissions
    if current_api_user.id == params[:id]
    @contributions = []
    @likes = current_api_user.likes
    @likes.each do |like|
      if like.contribution.type == "Post"
        @contributions << like.contribution if like.contribution
      end
    end
    render json: @contributions.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author), status: :ok
    else
      head :forbidden
    end
  end

  # GET /users/1/upvoted_comments
  def upvoted_comments
    if current_api_user.id == params[:id]
    @contributions = []
    @likes = current_api_user.likes
    @likes.each do |like|
      if like.contribution.type == "Comment" || like.contribution.type == "Reply"
        @contributions << like.contribution if like.contribution
      end
    end
    render json: @contributions.as_json(only: [:type, :id, :text, :user_id, :points, :created_at, :post_id, :contribution_id], :methods => :author), status: :ok
    else
      head :forbidden
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.id == current_api_user.id
      if @user.update(user_params)
        render json: @user.as_json(except: [:updated_at]), status: :ok
      else
        render json: @user.errors, status: :bad_request
      end
    else
      render json: '', status: :forbidden
    end
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :about)
  end
end