class EventJoinersController < ApplicationController

  def create
    @ej = EventJoiner.new event_joiner_params
    if @ej.save
      event = Event.find @ej.event_id
      event.delay.set_state
      render json: { success: "Event Joiner created" }, status: :ok
    else
      render json: { error: @ej.errors.full_messages }, status: :bad_request
    end
  end

  def update
    @ej = EventJoiner.find params[:id]
    @event = @ej.event
    @ej.update event_joiner_params
    if @ej.save
      render json: { success: "Application Updated" }, status: :ok
      @event.delay.set_state
    else
      render json: { error: @ej.errors.full_messages },status: :bad_request
    end
  end

  private
  def event_joiner_params
    params.require(:event_joiner).permit(:id, :event_id, :entity_id, :status)
  end
end
