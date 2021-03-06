module Api::V1::Entity
  include Api::V1::Json

  def entity_json(entity, includes = [])
    attributes = %w(id name type description address latitude longitude social_media data created_at)

    api_json(entity, only: attributes)
  end

  def entities_json(entities, includes = [])
    entities.map { |e| entity_json e, includes }
  end
end
