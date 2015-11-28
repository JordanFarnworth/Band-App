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
          render json: {success: "Application Created!"}, status: :ok
        else
          render json:{error: @application.errors.messages}, status: :bad_request
        end
      end
    end
  end

  def decline_app
    @application = Application.find params[:id]
    if @application
      @application.status = 'declined'
      @application.save
      render json: {success: "Application Updated"}, status: 200
    else
      render json: {error: @application.errors.messages}, status: 500
    end
  end

  private
  def application_params
    params.require(:application).permit(:id, :start_time, :end_time, :status, :party_id, :band_id)
  end
end
