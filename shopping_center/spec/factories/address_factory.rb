FactoryGirl.define do
  factory :address do
    street_number 1234
    street "Sesame St."
    municipality "New York"
    governing_district "NY"
    postal_code "10001"
  end
end
