class UsersController < ApplicationController
  include Api::V1::User
  include PaginationHelper

  before_action :find_user_and_groups, only: [:show, :edit, :update, :destroy]
  before_action :find_users, only: [:index]

  def find_user_and_groups
    @user = User.find params[:id]
    @user_bands = @user.bands
    @user_parties = @user.parties
  end

  def find_users
    @users = User.all
  end

  def index
    respond_to do |format|
      format.json do
        render json: pagination_json(@users, :users_json), status: :ok
      end
      format.html do
        @users
      end
    end
  end

  def show
    includes = params[:include] || []
    respond_to do |format|
      format.json do
        render json: user_json(@user, includes), status: :ok
      end
      format.html do
        @user
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        if @user.update user_parameters
          render json: user_json(@user), status: :ok
        end
      end
    end
  end

  def password_confirmation
    @user = @current_user.try(:authenticate, params[:oldpassword])
    if @user
      render json: { valid: true }, status: :ok
    else
      render json: { valid: false }, status: :bad_request
    end
  end

  def available_usernames
    @user = User.find_by username: params[:user].try(:[], :username)
    if @user
      render json: { valid: false }, status: :bad_request
    else
      render json: { valid: true }, status: :ok
    end
  end

  def available_emails
    @user = User.find_by email: params[:user].try(:[], :email)
    if @user
      render json: { valid: false }, status: :bad_request
    else
      render json: { valid: true }, status: :ok
    end
  end

  private
  def user_parameters
    params.require(:user).permit(:username, :display_name, :email, :password, :state)
  end
end
