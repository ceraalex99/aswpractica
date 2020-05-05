class Api::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :api_auth
  skip_forgery_protection


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.where('tipo = ?','url').order('points DESC')
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: @post.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author)
  end

  def newest
    @posts = Post.all.order('created_at DESC')
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author)
  end

  def ask
    @posts = Post.all.where('tipo = ?','ask').order('points DESC')
    render json: @posts.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author)
  end

  def create
    # if post_params[:url] != "" and post = Post.find_by(url: post_params[:url])
    #   redirect_to api_post_path(post)
    # else
    @post = Post.new(post_params)
    @user = User.find_by_google_id(request.headers['Authorization'])
    @post.user = current_api_user

    if @post.save
      @user.karma += 1
      @user.save
      render json: @post.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author), status: :created
    else
      render json: @post.errors, status: :bad_request
    end
    # end
  end

  def update
    @user = current_api_user
    if @user.id == @post.user_id
      if @post.update(post_params)
        render json: @post.as_json(except: [:post_id, :contribution_id, :updated_at], :methods => :author), status: :created
      else
        render json: @post.errors, status: :bad_request
      end
    else
      render json: '', status: :forbidden
    end
  end

  def destroy
    if @user.id == @post.user_id
      @post.likes.destroy_all
      @post.destroy

      respond_to do |format|
        format.json { head :no_content }
      end
    else
      render json: '', status: :forbidden
    end
  end

  def user_submissions
    @posts = Post.all.where('user_id = ?', current_user.id)
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

