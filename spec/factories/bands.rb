FactoryGirl.define do
  factory :band, parent: :entity, class: Band do
    type 'Band'
    data do
      { 'genre' => 'Rock' }
    end
  end

end
