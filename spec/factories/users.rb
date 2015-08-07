FactoryGirl.define do
  factory :user do
    username { Forgery('internet').user_name }
    display_name { Forgery('name').full_name }
    email { Forgery('email').address }
    password { Forgery('basic').password }
    state 'active'
  end

end
