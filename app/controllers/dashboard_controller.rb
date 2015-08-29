class DashboardController < ApplicationController
  def index
    unless logged_in?
      redirect_to register_path
    end  
  end
end
