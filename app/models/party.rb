class Party < Entity

  scope :phone_number, -> (phone_number) { where("data -> 'phone_number' = ?", phone_number.to_s) }
  scope :email, -> (email) { where("data -> 'email' = ?", email.to_s) }
  scope :owner, -> (owner) { where("data -> 'owner' = ?", owner.to_s) }

  REQUIRED_DATA_ATTRIBUTES = %w(phone_number email owner)

  def search_bands(search_params, address)
    band = Band.create(address: address)
    band.geocode
    query = band.nearbys search_params['miles'] #['miles'] should always be present
    return query unless search_params[:name].present? || search_params[:email].present? || search_params[:genre].present?
    query1 = query.where("name ILIKE ?", "%#{search_params[:name]}%") if search_params[:name].present?
    query2 = query.where("data->'genre' ILIKE ?", "%#{search_params[:genre]}%") if search_params[:genre].present?
    query3 = query.where("data->'email' ILIKE ?", "%#{search_params[:email]}%") if search_params[:email].present?
    query1 ||= []
    query2 ||= []
    query3 ||= []
    results = query1 + query2 + query3
  end

  def validate_data
    REQUIRED_DATA_ATTRIBUTES.each do |attr|
      errors.add("data.#{attr}", 'is required') unless data.has_key?(attr) && data[attr]
    end
  end

  def favorites
    @favorites = Favorite.where party_id: self.id
  end

  def sent_invitations
    @events = self.events.pending
  end

  def owner
    data['owner']
  end

  def email
    data['email']
  end

  def phone_number
    data['phone_number']
  end

end
