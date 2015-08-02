class BandsController < ApplicationController
  include Api::V1::Entity
  include PaginationHelper

  before_action :find_band, only: [:show, :edit, :update, :destroy]
  before_action :find_bands, only: [:index]

  def find_band
    @band = Band.find params[:id]
  end

  def find_bands
    @bands = Band.all
  end

  def index
    respond_to do |format|
      format.json do
        render json: pagination_json(@bands, :entities_json), status: :ok
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: entity_json(@band), status: :ok
      end
    end
  end
end
