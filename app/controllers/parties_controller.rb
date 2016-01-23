class PartiesController < ApplicationController
  include Api::V1::Party
  include Api::V1::Event
  include PaginationHelper

  before_action :find_party, only: [:show, :edit, :update, :destroy]
  before_action :find_parties, only: [:index, :search]

  def find_party
    @party = Party.find params[:id]
  end

  def find_parties
    @parties = Party.all
  end

  def index
    if params[:search_term]
      t = params[:search_term]
      @parties = @parties.where('name LIKE ?', "%#{t}%")
    end
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

  def advanced_search
    respond_to do |format|
      format.html do
      end
      format.json do
        hash = {
          :name => params["name"],
          :owner => params["owner"],
          :miles => params["miles"]
        }
        name = params["name"]
        owner = params["owner"]
        miles = params["miles"]
        case
        when name == "" && owner.nil?
            parties = @current_entity.band_miles miles
            render json: parties_json(parties), status: :ok
          when name != "" && owner.nil?
            parties = @current_entity.search_by_name_miles name, miles
            render json: parties_json(parties), status: :ok
          when name == "" && owner
            parties = @current_entity.search_by_owner_miles name, miles
            render json: parties_json(parties), status: :ok
          when name != "" && owner != ""
            parties = @current_entity.search_by_name_owner_miles name, owner, miles
            render json: parties_json(parties), status: :ok
        end
      end
    end
  end

  def search_finished?
    render json: {:finished? => @search_finished}
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
          @party.add_user @current_user
          @party.delay.geocode_address
          render json: party_json(@party), status: :ok
        else
          render json: { errors: @party.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def update
    @party.delay.geocode_address
    if @party.update party_parameters
      render json: party_json(@party), status: :ok
    else
      render json: { errors: @party.errors.full_messages }, status: :bad_request
    end
  end

  private
  def party_parameters
    params.require(:party).permit(:name, :description, :address, :longitude, :latitude, social_media: [:twitter, :instagram, :facebook], data: [:email, :phone_number, :owner])
  end
end
