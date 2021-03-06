class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end  

  def ensure_that_signed_in
    redirect_to signin_path, notice:'You should be signed in!' if current_user.nil?
  end  

  def ensure_that_not_blocked
    redirect_to root_path, notice:'Your account is blocked!' if current_user && current_user.blocked?
  end

  def ensure_that_admin
    redirect_to root_path, notice:'You are not admin!' if current_user && !current_user.admin?
  end

  def ensure_that_there_are_comments
    redirect_to root_path, notice:'There are no comments yet!' if Comment.all.count < 1
  end

  def ensure_that_there_are_posts
    redirect_to root_path, notice:'There are no posts yet!' if Post.all.count < 1
  end
end
