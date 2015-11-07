class NotificationsController < ApplicationController
  before_action :find_notification, only: %i(destroy mark_as_read)

  def index
    @notifications = current_entity.notifications
    render json: @notifications, status: :ok
  end

  def mark_as_read
    @notification.mark_as_read!
    render json: @notification, status: :ok
  end

  def destroy
    @notification.destroy
    render nothing: true, status: :no_content
  end

  def find_notification
    @notification = Notification.find params[:id]
  end
end
