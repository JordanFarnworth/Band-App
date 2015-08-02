FactoryGirl.define do
  factory :entity_user do
    association :entity, factory: :entity
    association :user, factory: :user
  end

end
