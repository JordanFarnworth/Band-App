class MessagesController < ApplicationController
  include Api::V1::Message
  include PaginationHelper
  skip_before_action :verify_authenticity_token, only: [:create]

  before_action :find_message_thread, only: [:index], if: :api_request?

  def find_message_thread
    @message_thread = MessageThread.find params[:message_thread_id]
  end

  def index
    respond_to do |format|
      format.html do
        redirect_to root_path and return unless current_entity
        @message_threads = current_entity.message_threads.includes(:latest_message, :entities)
      end
      format.json do
        @messages = @message_thread.messages.reverse_chronological
        render json: messages_json(@messages, params[:include] || []), status: :ok
      end
    end
  end

  def create
    @recipient = Entity.find params[:message][:recipient_id]
    @message_thread = MessageThread.between_entities current_entity, @recipient
    unless @message_thread
      @message_thread ||= MessageThread.create
      @message_thread.message_participants.create entity: current_entity
      @message_thread.message_participants.create entity: @recipient
    end
    @message = @message_thread.messages.new message_params
    @message.sender = current_entity
    if @message.save
      @message_thread.message_participants.find_by(entity_id: @recipient.id).update(state: :unread)
      render json: message_json(@message), status: :ok
    else
      render json: @message.errors, status: :bad_request
    end
  end

  private
  def message_params
    params.require(:message).permit(:subject, :body)
  end
end
