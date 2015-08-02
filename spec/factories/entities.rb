FactoryGirl.define do
  factory :entity do
    name "MyString"
    description "MyText"
    social_media { Hash.new }
    data { Hash.new }
  end

end
