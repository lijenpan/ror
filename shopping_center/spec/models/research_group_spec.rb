require 'spec_helper'

describe ResearchGroup do
  before { @group = Factory.build(:research_group) }
  subject { @group }

  describe 'validations' do
    it { should validate_presence_of(:name) }

    describe 'name' do
      context 'when name is empty' do
        before { subject.name = nil }
        it { subject.should_not be_valid }
      end

      context 'when name is not empty' do

        it { subject.should be_valid }
      end
    end
  end

  describe 'associations' do
    it { should have_many(:researchers) }
    it { should have_one(:research_manager) }
  end

  describe 'methods' do
    before(:all) do
      @user1 = Factory.create(:researcher)
      @user2 = Factory.create(:researcher)
      @user3 = Factory.create(:researcher)
    end

    describe '.open_tasks' do
      context 'has no researchers' do
        it "should return empty when no researchers are in group" do
          subject.open_tasks.should be_empty
        end
      end

      context 'has researchers' do
        it "should return all researchers open tasks items" do
          3.times { @user1.tasks.create(Factory.build(:opened_task).attributes) }
          2.times { @user2.tasks.create(Factory.build(:closed_task).attributes) }
          5.times { @user3.tasks.create(Factory.build(:opened_task).attributes) }

          subject.researchers << @user1
          subject.open_tasks.count.should == 3

          subject.researchers << @user2
          subject.open_tasks.count.should == 3

          subject.researchers << @user3
          subject.open_tasks.count.should == 8
        end
      end
    end

    describe '.open_shopping_centers' do
      context 'has no researchers' do
        it "should return empty when no researchers are in group" do
          subject.open_shopping_centers.should be_empty
        end
      end

      context 'has researchers' do
        it "should return all researchers open tasks items" do
          3.times { @user1.shopping_centers.create(Factory.attributes_for(:waiting_on_researcher_shopping_center)) }
          2.times { @user2.shopping_centers.create(Factory.attributes_for(:waiting_on_manager_shopping_center)) }
          5.times { @user3.shopping_centers.create(Factory.attributes_for(:waiting_on_researcher_shopping_center)) }

          subject.researchers << @user1
          subject.open_shopping_centers.count.should == 3

          subject.researchers << @user2
          subject.open_shopping_centers.count.should == 3

          subject.researchers << @user3
          subject.open_shopping_centers.count.should == 8
        end
      end
    end
  end
end
