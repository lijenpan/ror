FactoryGirl.define do
  factory :research_manager, parent: :user, :class => 'ResearchManager' do

    research_group
  end
end
