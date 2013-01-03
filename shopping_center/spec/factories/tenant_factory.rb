FactoryGirl.define do
  factory :tenant do
    name "Auntie Ann's Pretzels"

    shopping_center

    factory :anchor_tenant do
      is_anchor true
    end
  end
end
