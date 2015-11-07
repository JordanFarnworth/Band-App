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

  def decline_invite
    event_id = params['event']['id']
    ej = EventJoiner.where(event_id: event_id, entity_id: current_entity.id).first
    if ej
      ej.status = 'declined'
      ej.save
      event = Event.find event_id
      event.delay.set_state
      render json: "Event Updated!", status: :ok
    else
      render json: 'No Event Joiner Found', status: :bad_request
    end
  end

  def accept_invite
    event_id = params['event']['id']
    ej = EventJoiner.where(event_id: event_id, entity_id: current_entity.id).first
    if ej
      ej.status = 'accepted'
      ej.save
      event = Event.find event_id
      event.delay.set_state
      render json: "Event Updated!", status: :ok
    else
      render json: 'No Event Joiner Found', status: :bad_request
    end
  end

  def invite
    bands = params[:bands]
    @event.state = 'pending'
    @event.save
    bands = bands.uniq
    bands.each do |band|
      EventJoiner.create_band_ej(band, @event.id)
      Notification.create_for_entity!(band, @event, "You've been invited to play at #{@event.title}!")
    end
    @event.set_state
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
    if @event.update event_params
      render json: event_json(@event), status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :bad_request
    end
    @event.set_state
  end

  private
  def event_params
    params.require(:event).permit(:id, :title, :description, :start_time, :end_time, :price, :recurrence_pattern, :recurrence_ends_at, :state)
  end

end
