class Band < Entity
  before_create :generate_defaults

  scope :genre, -> (genre) { where("data -> 'genre' = ?", genre.to_s) }
  REQUIRED_DATA_ATTRIBUTES = %w(genre email address youtube_link phone_number)
  REQUIRE_SOCIAL_MEDIA_ATTRIBUTES = %w(twitter facebook)

  def validate_data
    REQUIRED_DATA_ATTRIBUTES.each do |attr|
      errors.add("data.#{attr}", 'is required') unless data.has_key?(attr) && data[attr]
    end

    REQUIRE_SOCIAL_MEDIA_ATTRIBUTES.each do |attr|
      errors.add("social_media.#{attr}", 'is required') unless social_media.has_key?(attr) && social_media[attr]
    end

    errors.add("data.youtube_link", 'must be a valid youtube url') unless data['youtube_link'].match(ConversionHelper::YOUTUBE_PATTERN)
    errors.add("social_media.facebook", 'must be a valid facebook url') unless social_media['facebook'].match(ConversionHelper::FACEBOOK_PATTERN)
    errors.add("data.phone_number", 'must be a valid phone number') unless data['phone_number'].match(ConversionHelper::PHONE_NUMBER_PATTERN)
  end

  def generate_defaults
    self.data['youtube_link'] ||= ''
    self.data['address'] ||= ''
    self.data['phone_number'] ||= ''
    self.data['email'] ||= ''
    self.data['audio_file_1'] ||= ''
    self.data['audio_file_2'] ||= ''
    self.social_media['twitter'] ||= ''
    self.social_media['facebook'] ||= ''
    self.social_media['instagram'] ||= ''
  end

  def genre
    data['genre']
  end

  def youtube_embed_url
    ConversionHelper.convert_youtube_link data['youtube_link']
  end
end
