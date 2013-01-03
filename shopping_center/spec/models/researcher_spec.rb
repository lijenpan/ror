require 'spec_helper'

describe Researcher do
  subject { Factory.build(:researcher) }

  describe 'validations' do
  end

  describe 'associations' do
    it { should belong_to(:research_group) }
    it { should have_many(:shopping_centers) }
    it { should have_many(:collected_retailers) }
  end

  describe 'methods' do
    describe '.manager' do
      it 'should always refer to the manager of the associated research_group' do
        subject.research_group.research_manager.should == subject.manager
      end
    end

    describe '.tasksload' do
      before do
        3.times do
          owi = Factory.build(:opened_task)
          subject.tasks << owi
        end

        2.times do
          owi = Factory.build(:closed_task)
          subject.tasks << owi
        end
      end

      it 'should return the number of open tasks assigned to current researcher' do
        subject.tasksload.should == 3
      end
    end
  end
end
