class EntitiesController < ApplicationController
  include Api::V1::Entity

  before_action :find_entity

  def find_entity
    @entity = Entity.find params[:id]
  end

  def index

  end

  def show
    respond_to do |format|
      format.json do
        render json: entity_json(@entity), status: :ok
      end
    end
  end
end
