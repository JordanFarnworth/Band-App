class PaymentsController < ApplicationController
  include Api::V1::Payment

  PARAMS_FOR_JOB = %w(payment_method_nonce)

  def new
    @payment ||= current_entity.payments.new
  end

  def create
    @payment = current_entity.payments.new payment_params
    if @payment.save
      ReceivePaymentJob.perform_later(@payment, params.slice(*PARAMS_FOR_JOB))
      flash[:success] = 'Thank you!  Your account will be updated momentarily.'
      redirect_to payment_path @payment.uuid
    else
      flash[:error] = 'Oops, there was a problem processing your request'
      render 'new'
    end
  end

  def index
    if api_request?
      @payments = current_entity.payments.order(created_at: :desc)
      @payments = @payments.failed if params[:scope] == 'failed'
      @payments = @payments.initiated if params[:scope] == 'initiated'
      @payments = @payments.processed if params[:scope] == 'processed'
    else
      @payments = []
    end
    respond_to do |format|
      format.json do
        render json: payments_json(@payments), status: :ok
      end
      format.html
    end
  end

  def show
    @payment = current_entity.payments.find_by! uuid: params[:id]
  end

  private
  def payment_params
    params.require(:payment).permit(:amount)
  end
end
