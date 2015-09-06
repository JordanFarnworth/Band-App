class ApplicationsController < ApplicationController

  def create
    @application = Application.new application_params
    respond_to do |format|
      format.json do
        if @application.save
          debugger
          @requestor = ApplicationJoiner.new
          @requestor.entity_id = params["application"]["band_id"].to_i
          @requestor.application_id = @application.id
          @requestor.relation = 'requestor'
          @requestor.save
          @requestee = ApplicationJoiner.new
          @requestee.entity_id = params["application"]["party_id"].to_i
          @requestee.application_id = @application.id
          @requestee.relation = 'requestee'
          @requestee.save
          render json: nil, status: 200
        else
          render json: nil, status: 200
        end
      end
    end
  end

  private

  def application_params
    params.require(:application).permit(:id, :start_time, :end_time, :status, :party_id, :band_id)
  end

end
