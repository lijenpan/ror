FactoryGirl.define do
  factory :user do
    first_name "Person"
    sequence(:last_name) { |n| "#{n}" }
    email { "#{first_name.first}#{last_name}@pps.com" }
    password "1234567890"
    password_confirmation { password }

    trait :invalid_email do
      email nil
    end

    factory :invalid_user, traits: [:invalid_email]
  end
end
