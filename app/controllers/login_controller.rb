class LoginController < ApplicationController
  include ApplicationHelper

  def verify
    @user = User.active.find_by(username: params[:user][:username]).try(:authenticate, params[:user][:password])
    session[:current_user_id] = @user.id if @user
    if @user
      render json: { success: "logged in" }, status: :ok
    else
      render json: { error: "wrong username or password" }, status: :bad_request
    end
  end

  def logout
    session.delete :current_user_id
    redirect_to :root
  end

  def register
    @user ||= User.new
  end

  def landing
    @user ||= User.new
  end

  def verify_register
    @user = User.new register_params
    if @user.save
      UserMailer.register_email(@user, host_url + register_confirm_path(token: @user.registration_token)).deliver_later
      render json: { success: "Registered User!"}, status: :ok
    else
      render json: { error: @user.error.full_messages }, status: :bad_request
      flash[:error] = "Registration failed, please try signing up again"
    end
  end

  def confirm_registration
    @user = User.pending.find_by(registration_token: params[:token])
    if @user
      @user.confirm!
      session[:current_user_id] = @user.id
      flash[:success] = 'Success!  Your account has been confirmed, and you are now logged in.'
      redirect_to :root
    else
      redirect_to :root
      flash[:error] = "Oops, we couldn't find a user to confirm with the given token."
    end
  end

  private
  def register_params
    params.require(:user).permit(:username, :display_name, :email, :password, :password_confirmation)
  end
end
