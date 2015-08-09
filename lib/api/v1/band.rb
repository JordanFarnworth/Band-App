module Api::V1::Band
  include Api::V1::Entity

  def band_json(band, includes = [])
    entity_json(band, includes).tap do |hash|
      hash['data']['embedded_youtube_video'] = band.youtube_embed_url
    end
  end

  def bands_json(bands, includes = [])
    bands.map { |b| band_json(b, includes) }
  end
end
