class Api::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :api_auth, except: :create
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
    Contribution.current_user = current_api_user
    @id = params[:id]
    @posts = Post.all.where("user_id= ?", @id).order('points DESC')
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => [:author, :liked])
  end

  # GET /users/1/comments
  def comments
    Contribution.current_user = current_api_user
    @id = params[:id]
    @comments = Comment.all.where("user_id = ?", @id) + Reply.all.where("user_id = ?", @id)
    @comments = @comments.sort_by { |e| -e[:points] }
    render json: @comments.as_json(only: [:type, :id, :text, :user_id, :points, :created_at, :post_id, :contribution_id], :methods => [:author, :liked]), status: :ok
  end

  # GET /users/1/upvoted_submissions
  def upvoted_submissions
    Contribution.current_user = current_api_user
    @user = User.find(params[:id])
    if current_api_user.id == @user.id
      @contributions = []
      @likes = current_api_user.likes
      @likes.each do |like|
        if like.contribution.type == "Post"
          @contributions << like.contribution if like.contribution
        end
      end
      @contributions = @contributions.sort_by { |e| -e[:points] }
      render json: @contributions.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author), status: :ok
    else
      head :forbidden
    end
  end

  # GET /users/1/upvoted_comments
  def upvoted_comments
    Contribution.current_user = current_api_user
    @user = User.find(params[:id])
    if current_api_user.id == @user.id
      @contributions = []
      @likes = current_api_user.likes
      @likes.each do |like|
        if like.contribution.type == "Comment" || like.contribution.type == "Reply"
          @contributions << like.contribution if like.contribution
        end
      end
      @contributions = @contributions.sort_by { |e| -e[:points] }
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

  def create
    if user = User.find_by_google_id(params[:google_id])
      render json: user.as_json(only: [:id]), status: :ok
    else
      @user = User.new
      @user.name = params[:name]
      @user.google_id = params[:google_id]
      @user.save
      render json: @user.as_json(only: [:id, :google_id, :name]), status: :created
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
