FactoryGirl.define do
  factory :band, parent: :entity, class: Band do
    type 'Band'
    data do
      {
        'genre' => 'Rock',
        'email' => Forgery::Email.address,
        'youtube_link' => 'https://youtube.com/watch?v=whatever',
        'phone_number' => Forgery::Address.phone
      }
    end
  end

end
