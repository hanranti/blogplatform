class LikesController < ApplicationController
  before_action :set_like, only: [:show, :edit, :update, :destroy]
  before_action :set_comments, only: [:new, :edit, :create, :update]
  before_action :ensure_that_signed_in, only: [:create, :update, :destroy]
  before_action :ensure_that_not_blocked, only: [:create, :update, :destroy]

  # GET /likes
  # GET /likes.json
  def index
    @comments = Comment.top_last_week
  end

  # GET /likes/1
  # GET /likes/1.json
  def show
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes
  # POST /likes.json
  def create
    @like = Like.where(:user_id => like_params[:user_id], :comment_id => like_params[:comment_id]).first
    if not @like
      @like = Like.new(like_params)
    elsif @like.user == current_user
      @like.update_attribute(:like, like_params[:like])
    end

    respond_to do |format|
      if current_user && @like.save
        format.html { redirect_to :back, notice: 'Like was successfully created.' }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likes/1
  # PATCH/PUT /likes/1.json
  def update
    respond_to do |format|
      if @like.user == current_user && @like.update(like_params)
        format.html { redirect_to :back, notice: 'Like was successfully updated.' }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like.user == current_user && @like.destroy
    respond_to do |format|
      format.html { redirect_to likes_url, notice: 'Like was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    def set_comments
      @comments = Comment.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def like_params
      params.permit(:like, :user_id, :comment_id)
    end
end
