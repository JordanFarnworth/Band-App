class DashboardController < ApplicationController

  def index
    unless logged_in?
      redirect_to landing_path
    end
  end

  def calendar
  end
end
