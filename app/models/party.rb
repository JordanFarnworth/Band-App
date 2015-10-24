class Party < Entity

  scope :phone_number, -> (phone_number) { where("data -> 'phone_number' = ?", phone_number.to_s) }
  scope :email, -> (email) { where("data -> 'email' = ?", email.to_s) }
  scope :owner, -> (owner) { where("data -> 'owner' = ?", owner.to_s) }

  REQUIRED_DATA_ATTRIBUTES = %w(phone_number email owner)

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
