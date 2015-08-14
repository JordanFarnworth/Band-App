module Api::V1::Party
  include Api::V1::Entity

  def party_json(party, includes = [])
    entity_json(party, includes)
  end

  def parties_json(parties, includes = [])
    parties.map { |b| party_json(b, includes) }
  end
end
