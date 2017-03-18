class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password]) && !user.blocked
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    elsif user && user.blocked
      redirect_to :back, notice: "Account frozen. Please contact administrators."
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end

  def create_oauth
    current_user.update_attribute :github_username, (env["omniauth.auth"].info.nickname)
    redirect_to :back, notice: "User connected to github account"
  end
end
