class FavoritesController < ApplicationController
  def create
    @favorite = Favorite.new favorite_params
    if @favorite.save
      render json: 200, status: :ok
    else
      render json: { errors: @favorite.error.full_messages }, status: :bad_request
    end
  end

  def check_band
    @favorite = Favorite.band.where(band_id: params[:band_id], party_id: params[:party_id]).first
    if @favorite
      render json: { favorite: "true" }
    else
      render json: { favorite: "false" }
    end
  end

  def check_party
    @favorite = Favorite.party.where(band_id: params[:band_id], party_id: params[:party_id]).first
    if @favorite
      render json: { favorite: "true" }
    else
      render json: { favorite: "false" }
    end
  end

  def add_remove_band
    @favorite = Favorite.band.where(band_id: params[:favorite][:band_id], party_id: params[:favorite][:party_id]).first
    if @favorite
      @favorite.destroy
      render json: {deleted: 'true'}, status: :ok
    else
      @favorite = Favorite.new favorite_params
      @favorite.save
      render json: { created: "true" }, status: :ok
    end
  end

  def add_remove_party
    @favorite = Favorite.party.where(favorite_params).first_or_initialize
    if @favorite.persisted?
      @favorite.destroy
      render json: {deleted: 'true'}, status: :ok
    else
      @favorite.save
      render json: { created: "true" }, status: :ok
    end
  end

  private
  def favorite_params
    params.require(:favorite).permit(:band_id, :party_id, :owner)
  end
end
