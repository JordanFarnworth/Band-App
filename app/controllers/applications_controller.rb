class ApplicationsController < ApplicationController

  def create
    ap = application_params
    ap[:start_time] = DateTime.strptime ap[:start_time], '%m/%d/%Y %I:%M %p'
    ap[:end_time] = DateTime.strptime ap[:end_time], '%m/%d/%Y %I:%M %p'
    debugger
    @application = Application.new ap
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
      render json: {success: "Application Updated"}, status: :ok
    else
      render json: {error: @application.errors.messages}, status: :bad_request
    end
  end

  private
  def application_params
    params.require(:application).permit(:id, :start_time, :end_time, :status, :party_id, :band_id)
  end
end
