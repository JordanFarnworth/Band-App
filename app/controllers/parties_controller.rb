class PartiesController < ApplicationController
  include Api::V1::Party
  include PaginationHelper

  before_action :find_party, only: [:show, :edit, :update, :destroy]
  before_action :find_parties, only: [:index]

  def find_party
    @party = Party.find params[:id]
  end

  def find_parties
    @parties = Party.all
  end

  def index
    respond_to do |format|
      format.html do

      end
      format.json do
        render json: pagination_json(@parties, :parties_json), status: 200
      end
    end
  end

  def show
    respond_to do |format|
      format.html do

      end
      format.json do
        render json: party_json(@party), status: :ok
      end
    end
  end

  def create
    @party = Party.new party_parameters
    respond_to do |format|
      format.html do
        if @party.save
          flash[:success] = 'Party Created!'
          redirect_to @party
        else
          render 'new'
        end
      end
      format.json do
        if @party.save
          render json: party_json(@party), status: :ok
        else
          render json: { errors: @party.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def update

  end

  private
  def party_parameters
    params.require(:party).permit(:name, :description, :address, :longitude, :latitude, social_media: [:twitter, :instagram, :facebook], data: [:email, :phone_number, :owner])
  end
end
