class EventsController < ApplicationController
  include Api::V1::Event

  #probably a lot in this controller could be better

  before_action :find_event, only: [:show, :edit, :update, :destroy, :invite]
  before_action :find_entity, only: :events


  def find_event
    @event = Event.find params[:id]
  end

  def create
    ep = event_params
    start_time = event_params[:start_time]
    ep[:start_time] = DateTime.strptime start_time, '%m/%d/%Y %I:%M %p'
    end_time = event_params[:end_time]
    ep[:end_time] = DateTime.strptime end_time, '%m/%d/%Y %I:%M %p'
    @event = Event.new ep
    if @event.save
      @event.delay.geocode_address
      EventJoiner.create_party_ej(params[:party], @event.id)
      render json: event_json(@event), status: :ok
    else
      render json: { error: @event.errors.full_messages }, status: :bad_request
    end
  end

  def deny_applications
    @ej = EventJoiner.find params[:id]
    event = ej.event
    event.delay.deny_applications params[:id]
    render json: { success: "Applications Denied" }, status: :ok
  end

  def create_accepted_event
    @application = Application.find params[:application]
    @application.accept_application
    @event = Event.new event_params
    if @event.save
      EventJoiner.create_party_ej(params[:party], @event.id)
      EventJoiner.accept_band_ej(params[:band], @event.id)
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
      render json: {success: "Event Updated!"}, status: :ok
    else
      render json: {error: 'No Event Joiner Found'}, status: :bad_request
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
      render json: { success: "Event Updated!"}, status: :ok
    else
      render json: {error: 'No Event Joiner Found'}, status: :bad_request
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
    ep = event_params
    start_time = event_params[:start_time]
    ep[:start_time] = DateTime.strptime start_time, '%m/%d/%Y %I:%M %p'
    end_time = event_params[:end_time]
    ep[:end_time] = DateTime.strptime end_time, '%m/%d/%Y %I:%M %p'
    if @event.update ep
      render json: event_json(@event), status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :bad_request
    end
    @event.set_state
  end

  private
  def event_params
    params.require(:event).permit(:id, :address, :title, :description, :start_time, :end_time, :price, :recurrence_pattern, :recurrence_ends_at, :state, :is_public)
  end
end
