module Api::V1::Event
  include Api::V1::Json

  def event_json(event, includes = [])
    attributes = %w(id title description start_time end_time recurrence_pattern recurrence_ends_at state price)

    api_json(event, only: attributes)
  end

  def events_json(events, includes = [])
    events.map { |e| event_json e, includes }
  end
end
