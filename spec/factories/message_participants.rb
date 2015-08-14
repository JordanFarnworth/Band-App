FactoryGirl.define do
  factory :message_participant do
    association :message_thread, factory: :message_thread
    association :entity, factory: :entity
  end

end
