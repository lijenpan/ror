FactoryGirl.define do
  factory :collection_instance do

    collected_on { DateTime.now }

    retailer
    association :collector, factory: :user

    trait :harvested do
      harvested true
    end

    factory :harvested_collection_instance, traits: [:harvested]
  end
end
