FactoryGirl.define do
  factory :shopping_center do
    name "New Shopping Center"

    researcher
    research_manager

    trait :invalid_name do
      name nil
    end

    trait :researcher do
      state "researcher_collecting"
    end

    trait :research_manager do
      state "manager_collecting"
    end

    trait :incomplete do
      state "incomplete"
    end

    trait :searchable do
      state "searchable"
    end

    factory :invalid_shopping_center, traits: [:invalid_name]
    factory :waiting_on_researcher_shopping_center, traits: [:researcher]
    factory :waiting_on_manager_shopping_center, traits: [:research_manager]
    factory :searchable_shopping_center, traits: [:searchable]
    factory :incomplete_shopping_center, traits: [:incomplete]
  end
end
