class DashboardController < ApplicationController
  before_action :check_auth

  def calendar
  end

  def index
    if @current_entity
      return
    elsif @current_user.user_data[:user_entity_type] === 'none'
      render '_pickentity'
    elsif @current_user.user_data[:user_entity_type] === 'band'
      render '_banddashboard'
    elsif @current_user.user_data[:user_entity_type] === 'party'
      render '_partydashboard'
    end
  end

  def check_auth
    unless logged_in?
      redirect_to landing_path
      flash[:warning] = 'Must be logged in'
    end
  end

  def find_pending_applications
    @pending_general_applications = @current_entity.applications.pending.includes(:band)
    events = @current_entity.events.includes(:event_joiners)
    @pending_event_applications = []
    events.each do |event|
      event_joiners = event.event_joiners.includes(:entity, :event)
      event_joiners.each do |ej|
        if ej.status == "application"
          @pending_event_applications << ej
        else
          next
        end
      end
    end
    @pending_event_applications
  end

  def find_band_applications
    @entity_general_applications = @current_entity.applications.includes(:party)
    @entity_event_joiners = @current_entity.event_joiners
    @pending_applications = @entity_general_applications.pending
    @declined_applications = @entity_general_applications.declined
    @entity_event_applications = @entity_event_joiners.application
    @denied_entity_event_applications = @entity_event_joiners.denied
  end

  def find_party_dashboard_events
    @events = @current_entity.events
    @accepted_events = @events.accepted
    @pending_events = @events.pending
    @public_events = @events.open
    @private_events = @events.closed
  end

  def find_band_dashboard_events
    @events = @current_entity.events
    @accepted_events = @events.accepted
    @pending_invitations = @current_entity.invitations
  end

  def find_party_favorites
    @party_favorites = @current_entity.favorites.party
  end

  def find_band_favorites
    @band_favorites = @current_entity.favorites.band
  end

  def applications
    if @current_user.user_data[:user_entity_type] == "band"
      find_band_applications
      render 'bands/_banddashapplications'
    else
      find_pending_applications
      render 'parties/_partydashapplication'
    end
  end

  def events
    if @current_entity.type == "Band"
      find_band_dashboard_events
      render 'bands/_banddashevents'
    else
      find_party_dashboard_events
      render 'parties/_partydashevents'
    end
  end

  def favorites
   if @current_user.user_data[:user_entity_type] == "band"
     find_band_favorites
     render 'bands/_banddashfavorites'
   else
     find_party_favorites
     render 'parties/_partydashfavorites'
   end
  end

  def edit_entity
   if @current_user.user_data[:user_entity_type] == "band"
     render 'bands/_banddasheditband'
   else
     render 'parties/_partydasheditparty'
   end
  end

  def self
  end
end
