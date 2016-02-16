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

  def favorites
    @favorites = Favorite.where(band_id: self.id)
  end

  def invitations
    @invitations = EventJoiner.pending.where(entity_id: self.id)
    @invitations
  end

  def search_parties(search_params, address)
    party = Party.create(address: address)
    party.geocode
    query = party.nearbys search_params['miles'] #['miles'] should always be present
    return query unless search_params[:name].present? || search_params[:owner].present?
    query1 = query.where("name ILIKE ?", "%#{search_params[:name]}%") if search_params[:name].present?
    query2 = query.where("data->'owner' ILIKE ?", "%#{search_params[:owner]}%") if search_params[:owner].present?
    query1 ||= []
    query2 ||= []
    results = query1 + query2
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
