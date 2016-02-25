FactoryGirl.define do
  factory :payment do
    entity
    gateway 'braintree'
    amount { 24.99 }
  end
end
