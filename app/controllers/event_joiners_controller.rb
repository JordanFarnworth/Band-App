class EventJoinersController < ApplicationController

  before_action :find_event_joiner, only: :update

  def find_event_joiner
    @ej = EventJoiner.find params[:id]
  end

  def create
    @ej = EventJoiner.new event_joiner_params
    if @ej.save
      @event = @ej.event
      @event.delay.set_state
      render json: { success: "Event Joiner created" }, status: :ok
    else
      render json: { error: @ej.errors.full_messages }, status: :bad_request
    end
  end

  def update
    @event = @ej.event
    @ej.update event_joiner_params
    if @ej.save
      @event.delay.set_state
      render json: { success: "Application Updated" }, status: :ok
    else
      render json: { error: @ej.errors.full_messages },status: :bad_request
    end
  end

  private
  def event_joiner_params
    params.require(:event_joiner).permit(:id, :event_id, :entity_id, :status)
  end
end
