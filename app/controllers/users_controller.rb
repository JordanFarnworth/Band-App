class UsersController < ApplicationController
  include Api::V1::User
  include PaginationHelper

  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :find_users, only: [:index]

  def find_user
    @user = User.find params[:id]
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
    respond_to do |format|
      format.json do
        render json: user_json(@user), status: :ok
      end
      format.html do
        @user
      end
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
end
