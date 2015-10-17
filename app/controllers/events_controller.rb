class EventsController < ApplicationController
  include Api::V1::Event

  before_action :find_event, only: [:show, :edit, :update, :destroy, :invite]
  before_action :find_entity, only: :events


  def find_event
    @event = Event.find params[:id]
  end

  def create
    @event = Event.new event_params
    if @event.save
      EventJoiner.create_party_ej(params[:party], @event.id)
      render json: event_json(@event), status: :ok
    else
      render json: { error: @event.errors.full_messages }, status: :bad_request
    end
  end

  def find_entity
    @entity = Entity.find params[:id]
  end

  def destroy
    joiners = EventJoiner.where(event_id: @event.id)
    joiners.destroy_all
    if @event.destroy
      render json: event_json(@event), status: :ok
    else
      render json: { error: 'deleting user failed' }, status: :bad_request
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: event_json(@event), status: :ok
      end
      format.html do

      end
    end
  end

  def invite
    bands = params[:bands]
    bands.uniq.each do |band|
      EventJoiner.create_band_ej(band, @event.id)
    end
    render json: event_json(@event), status: :ok
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
    debugger
    if @event.update event_params
      render json: event_json(@event), status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :bad_request
    end
  end

  private
  def event_params
    params.require(:event).permit(:id, :title, :description, :start_time, :end_time, :price, :recurrence_pattern, :recurrence_ends_at, :state)
  end

end
