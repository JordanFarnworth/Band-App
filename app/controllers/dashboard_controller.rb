class DashboardController < ApplicationController
  before_action :check_auth

  def check_auth
    unless logged_in?
      redirect_to landing_path
    end
  end

  def index
  end

  def calendar
  end

  def applications
  end

  def events
  end

  def favorites
  end

  def edit_entity
  end

  def self
  end
end
