class BandsController < ApplicationController
  include Api::V1::Entity
  include PaginationHelper

  before_action :find_band, only: [:show, :edit, :update, :destroy]
  before_action :find_bands, only: [:index]

  def find_band
    @band = Band.find params[:id]
    unless @band.data.has_value?("youtube_converted_yes")
      yt_convert = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
      yt_id = @band.data["youtube_link"].match(yt_convert)[2]
      @band.data["youtube_embed_link"] = "https://www.youtube.com/embed/#{yt_id}"
      @band.data["youtube_converted"] = "youtube_converted_yes"
      @band.save
    end
  end

  def find_bands
    @bands = Band.all
  end

  def convert_youtube_link

  end

  def index
    respond_to do |format|
      format.html do

      end
      format.json do
        render json: pagination_json(@bands, :entities_json), status: 200
      end
    end
  end

  def show
    respond_to do |format|
      format.html do

      end
      format.json do
        render json: entity_json(@band), status: :ok
      end
    end
  end
end
