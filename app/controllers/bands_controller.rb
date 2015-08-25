class BandsController < ApplicationController
  include Api::V1::Band
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
      format.html do
      end
      format.json do
        render json: pagination_json(@bands, :bands_json), status: 200
      end
    end
  end

  def show
    respond_to do |format|
      format.html do

      end
      format.json do
        render json: band_json(@band), status: :ok
      end
    end
  end

  def new
    respond_to do |format|
      format.json do
        @band = Band.new
      end
    end
  end

  def create
    @band = Band.new band_parameters
    respond_to do |format|
      format.html do
        if @band.save
          flash[:success] = 'Band Created!'
          redirect_to @band
        else
          render 'new'
        end
      end
      format.json do
        if @band.save
          @band.add_user(@current_user, role = "owner")
          @band.delay.geocode_address
          render json: band_json(@band), status: :ok
        else
          render json: { errors: @band.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def update
    @band.delay.geocode_address
    if @band.update band_parameters
      render json: band_json(@band), status: :ok
    else
      render json: { errors: @band.errors.full_messages }, status: :bad_request
    end
  end

  private
  def band_parameters
    params.require(:band).permit(:name, :description, :address, :longitude, :latitude, social_media: [:twitter, :instagram, :facebook], data: [:email, :genre, :phone_number, :youtube_link])
  end
end
