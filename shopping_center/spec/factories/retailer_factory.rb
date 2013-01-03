FactoryGirl.define do
  factory :retailer do
    name "name"
    primary_sector "primary sector"
    company "company"
    store_count 1
    sectors {[]}
    initiated DateTime.current

    association :initiated_by, factory: :user

    trait :invalid_name do
      name nil
    end

    factory :banana_republic do
      name "Banana Republic"
      primary_sector "Clothing"
      company "Gap Inc."
      sectors {["Mens", "Womens", "Casual"]}
    end

    factory :invalid_retailer, traits: [:invalid_name]
  end
end
