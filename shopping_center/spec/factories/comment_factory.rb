FactoryGirl.define do
  factory :comment do
    sequence(:author) {|n| "Some Guy#{n}" }
    sequence(:body) {|n| "Some Text#{n}" }

    trait :invalid_body do
      body nil
    end

    trait :invalid_author do
      author nil
    end

    factory :invalid_comment, traits: [:invalid_body]
  end
end
