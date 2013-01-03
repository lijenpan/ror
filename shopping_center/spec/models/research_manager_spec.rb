require 'spec_helper'

describe ResearchManager do
  subject { Factory.create(:research_manager) }

  describe 'validations' do
  end

  describe 'associations' do
    it { should belong_to(:research_group) }
    it { should have_many(:shopping_centers) }
  end

  describe 'methods' do
    describe '.researchers' do
      it 'should return the researchers assigned to associated research_group' do
        subject.researchers.should  be_empty
        r = Factory.create(:researcher, research_group: subject.research_group)
        subject.researchers.first.should equal r
        subject.researchers.count.should equal 1
      end
    end
  end
end
