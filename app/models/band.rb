class Band < Entity
  scope :genre, -> (genre) { where("data -> 'genre' = ?", genre.to_s) }
  REQUIRED_DATA_ATTRIBUTES = %w(genre)

  def validate_data
    REQUIRED_DATA_ATTRIBUTES.each do |attr|
      errors.add("data.#{attr}", 'is required') unless data.has_key?(attr) && data[attr]
    end
  end

  def genre
    data['genre']
  end
end
