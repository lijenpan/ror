FactoryGirl.define do
  factory :bug do
    submitted_by "Person"
    sequence(:email) { |n| "#{submitted_by}#{n}@pps.com" }
    subject "Bug"
    url "url"
    severity 1
    description "description"

    trait(:invalid_submit_by) { submit_by nil }
    trait(:invalid_email) { email nil }
    trait(:invalid_subject) { subject nil }
    trait(:invalid_url) { url nil }
    trait(:invalid_severity) { severity nil }
    trait(:invalid_description) { description nil }

    factory :invalid_bug, traits: [:invalid_description]
  end
end
