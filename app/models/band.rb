class Band < Entity

  before_create :generate_defaults
  before_save :check_youtube_link

  scope :genre, -> (genre) { where("data -> 'genre' = ?", genre.to_s) }
  REQUIRED_DATA_ATTRIBUTES = %w(genre)

  def validate_data
    REQUIRED_DATA_ATTRIBUTES.each do |attr|
      errors.add("data.#{attr}", 'is required') unless data.has_key?(attr) && data[attr]
    end
  end

  def check_youtube_link

  end

  def generate_defaults
    self.data['youtube_link'] ||= ''
    self.data["youtube_converted"] = "no"
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
end
