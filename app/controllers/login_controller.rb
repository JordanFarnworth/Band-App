class LoginController < ApplicationController
  def verify
    @user = User.active.find_by(username: params[:username]).try(:authenticate, params[:password])
    session[:current_user_id] = @user.id if @user
    render 'verify', status: (@user ? :ok : :unauthorized)
  end

  def logout
    session.delete :current_user_id
    redirect_to :root
  end
end
