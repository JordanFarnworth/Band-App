FactoryGirl.define do
  factory :message do
    subject { Forgery('email').subject }
    body { Forgery('email').body }
    association :sender, factory: :entity
  end

end
