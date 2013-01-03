FactoryGirl.define do
  factory :task do
    sequence(:title) {|n| "The titlest title of all titles#{n}."}
    sequence(:description) {|n| "Go out to the shed and fetch me the water pail#{n}."}

    association :assignee, factory: :user
    association :creator, factory: :user

    trait :open do
      state "open"
    end

    trait :closed do
      state "closed"
    end

    trait :unassigned do
      assignee nil
    end

    trait :invalid_title do
      title nil
    end

    factory :opened_task, traits: [:open]
    factory :closed_task, traits: [:closed]
    factory :invalid_task, traits: [:invalid_title, :unassigned]
  end
end
