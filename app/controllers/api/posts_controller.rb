class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  skip_forgery_protection

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.where("tipo = ?","url").order("points DESC")
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: @post.as_json(except: [:post_id, :contribution_id, :updated_at])
  end

  def newest
    @posts = Post.all.order("created_at DESC")
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at])
  end

  def ask
    @posts = Post.all.where("tipo = ?","ask").order("points DESC")
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at])
  end

  def create
    if post_params[:url] != "" and post = Post.find_by(url: post_params[:url])
      redirect_to api_post_path(post)
    else
      @post = Post.new(post_params)
      @user = User.find_by_google_id(request.headers["Authorization"])
      @post.user = @user


      respond_to do |format|
        if @post.save
          @user.karma += 1
          @user.save
          format.json { render :show, status: :created, location: @post }
        else
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update

    respond_to do |format|
      if @post.update(post_params)
        format.json { render :show, status: :ok, location: @post }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.likes.destroy_all

    @post.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def user_submissions
    @posts = Post.all.where("user_id = ?", current_user.id)
    render json: @posts.as_json(except: [:post_id, :contribution_id])
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:url, :tipo, :title, :text)
  end

  def comment_params
    params.require(:comment).permit(:text, :post_id)
  end
end

