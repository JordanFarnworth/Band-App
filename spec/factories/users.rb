FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "user#{n}"
    end
    sequence :display_name do |n|
      "user#{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end
    password 'password'
    state 'active'
  end

end
