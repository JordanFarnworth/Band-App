class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  def set_current_user
    @current_user ||= User.active.find_by(id: session[:current_user_id])
  end

  def current_user
    @current_user
  end

  def logged_in?
    !!current_user
  end

  private :set_current_user
  helper_method :current_user
  helper_method :logged_in?
end
