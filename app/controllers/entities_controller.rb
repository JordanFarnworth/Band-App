class EntitiesController < ApplicationController
  before_action :find_entity, only: [:switch]

  def find_entity
    @entity = Entity.find params[:id]
  end

  def switch
    unless current_user && current_user.entities.where(id: @entity.id).exists?
      flash[:error] = "You can't switch to an entity with which you have no affiliation."
      redirect_to request.referrer || :root
      return
    end
    session[:current_entity_id] = @entity.id
    flash[:success] = "You are now viewing the site as #{@entity.name}"
    redirect_to request.referrer || :root
  end

  def cancel_view
    flash[:notice] = "You are no longer viewing the site as #{current_entity.name}" if current_entity
    session.delete :current_entity_id
    redirect_to request.referrer || :root
  end
end
