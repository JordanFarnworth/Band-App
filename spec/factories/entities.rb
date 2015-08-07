FactoryGirl.define do
  factory :entity do
    name { Forgery('name').company_name }
    description { Forgery('lorem_ipsum').paragraph }
    social_media { Hash.new }
    data { Hash.new }
  end

end
