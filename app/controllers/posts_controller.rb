class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :require_login, only: [:new, :edit, :create, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.where("tipo = ?","url").order("points DESC")
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  #GET /posts/newest
  def newest
    @posts = Post.all.order("created_at DESC")
  end

  # GET /posts/1/edit
  def edit
  end


  def ask
    @posts = Post.all.where("tipo = ?","ask").order("points DESC")
  end

  # POST /posts
  # POST /posts.json
  def create
    if post_params[:url] != "" and post = Post.find_by(url: post_params[:url])
      redirect_to post_path(post)
    else
      @post = Post.new(post_params)
      @post.user = current_user


      respond_to do |format|
        if @post.save
          @user = User.find(current_user.id)
          @user.karma += 1
          @user.save
          callback = cookies.signed[:callback]
          cookies.delete(:callback)
          format.html { redirect_to callback}
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    respond_to do |format|
      if @post.update(post_params)
        callback = cookies.signed[:callback]
        cookies.delete(:callback)
        format.html { redirect_to callback}
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  #
  # SUPERCLASS



  # GET /posts/my_submissions
  def my_submissions
    posts = Post.all.where("user_id = ?", current_user.id)
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
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:url, :tipo, :title, :text)
    end

end
