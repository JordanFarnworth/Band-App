FactoryGirl.define do
  factory :api_key do
    association :user, factory: :user
    key { SecureRandom.uuid }
  end

end
