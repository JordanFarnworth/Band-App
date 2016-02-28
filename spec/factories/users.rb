FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "#{Forgery('internet').user_name}-#{n}" }
    display_name { Forgery('name').full_name }
    email { Forgery('email').address }
    password { Forgery('basic').password }
    state 'active'
  end

end
