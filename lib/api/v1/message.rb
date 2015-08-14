module Api::V1::Message
  include Api::V1::Json

  def message_json(message, includes = [])
    attributes = %w(id subject body sender_id message_thread_id created_at updated_at)

    api_json(message, only: attributes)
  end

  def messages_json(messages, includes = [])
    messages.map { |m| message_json(m, includes) }
  end
end
