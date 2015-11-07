class ApplicationsController < ApplicationController

  def create
    @application = Application.new application_params
    band = params["application"]["band_id"].to_i
    party = params["application"]["party_id"].to_i
    respond_to do |format|
      format.json do
        if @application.save
          @requestor = ApplicationJoiner.new
          @requestor.create_band_joiner(band, @application.id)
          @requestee = ApplicationJoiner.new
          @requestee.create_party_joiner(party, @application.id)
          render json: nil, status: 200
        else
          render json: @application.errors.messages, status: 500
        end
      end
    end
  end

  def decline_app
    @application = Application.find params[:id]
    if @application
      @application.status = 'declined'
      @application.save
      render json: "Application Updated", status: :ok
    else
      render json: @application.errors.messages, status: 500
    end
  end

  private

  def application_params
    params.require(:application).permit(:id, :start_time, :end_time, :status, :party_id, :band_id)
  end

end
