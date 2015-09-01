class EventsController < ApplicationController
  include Api::V1::Event

  before_action :find_event, only: [:show, :edit, :update, :destroy, :events]
  before_action :find_entity, only: :events


  def find_event
    @event = Event.find params[:id]
  end

  def find_entity
    @entity = Entity.find params[:id]
  end

  def show
    respond_to do |format|
      format.json do
        render json: event_json(@event), status: :ok
      end
    end
  end

  def events
    @events = @entity.events
    respond_to do |format|
      format.json do
        render json: events_json(@events), status: :ok
      end
    end
  end

  def update
    if @event.update event_params
      render json: event_json(@event), status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :bad_request
    end
  end

  private
  def event_params
    params.require(:event).permit(:id, :title, :description, :start_time, :end_time)
  end

end
