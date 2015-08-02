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
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: user_json(@user), status: :ok
      end
    end
  end
end
