class MessagesController < ApplicationController
  include Api::V1::Message
  include PaginationHelper
  skip_before_action :verify_authenticity_token, only: [:create]

  before_action :find_message_thread, only: [:index]
  before_action :find_entity, only: [:create]

  def find_message_thread
    @message_thread = MessageThread.find params[:message_thread_id]
  end

  def find_entity
    @entity = Entity.find params[:entity_id]
  end

  def index
    @messages = @message_thread.messages
    render json: pagination_json(@messages, :messages_json), status: :ok
  end

  def create
    @recipient = Entity.find params[:message][:recipient_id]
    @message_thread = MessageThread.between_entities @entity, @recipient
    unless @message_thread
      @message_thread ||= MessageThread.create
      @message_thread.message_participants.create entity: @entity
      @message_thread.message_participants.create entity: @recipient
    end
    @message = @message_thread.messages.new message_params
    @message.sender = @entity
    if @message.save
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
