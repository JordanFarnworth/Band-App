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

  def search_by_name_owner_miles(name, owner, miles)
    @parties = Party.where('name LIKE ? AND owner LIKE ?', name, owner)
    @miles = self.band_miles miles
  end

  def search_by_name_miles(name, miles)
    results = []
    @parties = Party.where('name ILIKE ?', "%#{name}%")
    @miles = self.band_miles miles
    @miles.each do |m|
      @parties.each do |p|
        if m.name == p.name
          results << p
        end
      end
    end
    results.uniq
  end

  def search_by_owner_miles(owner, miles)
    results = []
    @parties = Party.where('owner LIKE ?', owner)
    @miles = self.band_miles miles
    @miles.each do |m|
      @parties.each do |p|
        if m.name == p.name
          results << p
        end
      end
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
