class MessageThreadsController < ApplicationController
  include Api::V1::MessageThread
  include PaginationHelper
  before_action :find_entity, only: [:index, :create]
  before_action :find_message_thread, only: [:show, :destroy]

  def find_entity
    @entity = current_user.entity
  end

  def find_message_thread
    @message_thread = MessageThread.find params[:id]
  end

  def index
    @message_threads = @entity.message_threads
    render json: pagination_json(@message_threads, :message_threads_json, params[:include] || []), status: :ok
  end

  def show
    render json: message_thread_json(@message_thread, params[:include] || []), status: :ok
  end
end
