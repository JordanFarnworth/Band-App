FactoryGirl.define do
  factory :message do
    subject { Forgery('email').subject }
    body { Forgery('email').body }
    association :sender, factory: :entity
    association :message_thread, factory: :message_thread
  end

end
