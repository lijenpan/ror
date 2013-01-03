FactoryGirl.define do
  factory :researcher, parent: :user, :class => 'Researcher' do

    research_group
  end
end
