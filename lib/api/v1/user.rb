module Api::V1::User
  include Api::V1::Json
  include Api::V1::Band
  include Api::V1::Party

  def user_json(user, includes = [])
    attributes = %w(id username display_name email state)

    api_json(user, only: attributes).tap do |hash|
      hash['bands'] = bands_json(user.bands) if includes.include?('bands')
      hash['parties'] = parties_json(user.parties) if includes.include?('parties')
    end
  end

  def users_json(users, includes = [])
    users.map { |u| user_json(u, includes) }
  end
end
