FactoryGirl.define do
  factory :message_participant do
    association :message, factory: :message
    association :entity, factory: :entity
  end

end
