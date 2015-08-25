class Band < Entity

  scope :genre, -> (genre) { where("data -> 'genre' = ?", genre.to_s) }
  scope :youtube_link, -> (youtube_link) { where("data -> 'youtube_link' = ?", youtube_link.to_s) }
  scope :phone_number, -> (phone_number) { where("data -> 'phone_number' = ?", phone_number.to_s) }
  scope :email, -> (email) { where("data -> 'email' = ?", email.to_s) }
  REQUIRED_DATA_ATTRIBUTES = %w(genre email youtube_link phone_number)

  def validate_data
    REQUIRED_DATA_ATTRIBUTES.each do |attr|
      errors.add("data.#{attr}", 'is required') unless data.has_key?(attr) && data[attr]
    end
  end

  def genre
    data['genre']
  end

  def youtube_link
    data['youtube_link']
  end

  def phone_number
    data['phone_number']
  end

  def email
    data['email']
  end

  def youtube_embed_url
    ConversionHelper.convert_youtube_link data['youtube_link']
  end
end
