module Api::V1::Message
  include Api::V1::Json
  include Api::V1::Entity

  def message_json(message, includes = [])
    attributes = %w(id subject body sender_id message_thread_id created_at updated_at)

    api_json(message, only: attributes).tap do |hash|
      hash['sender'] = entity_json(message.sender) if includes.include?('sender')
    end
  end

  def messages_json(messages, includes = [])
    messages = messages.includes(:sender) if includes.include?('sender')
    messages.map { |m| message_json(m, includes) }
  end
end
