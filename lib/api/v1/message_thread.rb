module Api::V1::MessageThread
  include Api::V1::Json
  include Api::V1::Entity
  include Api::V1::Message

  def message_thread_json(message_thread, includes = [])
    attributes = %w(id created_at updated_at)

    api_json(message_thread, only: attributes).tap do |hash|
      hash['latest_message'] = message_json(message_thread.latest_message) if includes.include? 'latest_message'
      hash['entities'] = entities_json(message_thread.entities) if includes.include? 'entities'
    end
  end

  def message_threads_json(message_threads, includes = [])
    message_threads = message_threads.includes(:latest_message) if includes.include? 'latest_message'
    message_threads = message_threads.includes(:entities) if includes.include? 'entities'
    message_threads.map { |mt| message_thread_json(mt, includes) }
  end
end
