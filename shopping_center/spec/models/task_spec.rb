require 'spec_helper'

describe Task do
  subject { Factory.build(:task) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:assignee) }
    it { should validate_presence_of(:creator) }
  end

  describe 'associations' do
    it { should belong_to(:creator) }
    it { should belong_to(:assignee) }
    it { should embed_many(:comments) }
  end

  describe 'methods' do
    describe '.open?' do
      it 'should return true if tasks item state is open' do
        subject.state = "open"
        subject.open?.should eq(true)

        subject.state = "closed"
        subject.open?.should eq(false)
      end

      it 'should return the opposite of closed?' do
        subject.open?.should eq(!subject.closed?)
      end
    end

    describe '.closed?' do
      it 'should return true if tasks item state is closed' do
        subject.closed?.should eq(false)
        subject.state = "closed"
        subject.closed?.should eq(true)
      end

      it 'should return the opposite of open?' do
        subject.closed?.should eq(!subject.open?)
      end
    end

    describe '.duration' do
      before(:each) do
        subject.created_at ||= 1.day.ago
      end

      it 'should return the difference between created at and now if state is open' do
        dt = DateTime.now
        subject.duration(dt).should eq(dt - subject.created_at.to_datetime)
      end

      it 'should return the difference between created at and closed_at if state is closed' do
        subject.close
        subject.closed_at.should_not be_nil
        diff = subject.closed_at.to_datetime - subject.created_at.to_datetime
        subject.duration.should eq(diff)
      end
    end
  end

  describe 'scope' do
    describe '#is?' do
      it "should fetch all tasks items if state parameter is nil" do
        Task.is?.count == 7
      end

      it "should fetch all tasks item corresponding to specific state" do
        Task.is?(:open).count.should == 0
        Task.is?(:closed).count.should == 0

        3.times { Factory.create(:opened_task) }
        4.times { Factory.create(:closed_task) }

        Task.is?(:open).count.should == 3
        Task.is?(:closed).count.should == 4
      end
    end

    describe '#assigned_to' do
      before(:each) do
        @user1 = Factory.create(:user)
        @user2 = Factory.create(:user)
        @user3 = Factory.create(:user)

        3.times { @user1.tasks << Factory.create(:task) }
        2.times { @user2.tasks << Factory.create(:task) }
        5.times { @user3.tasks << Factory.create(:task) }
      end

      it "should return all assigned tasks items if no ids are provided" do
        Task.assigned_to.count.should == 10
      end

      it "should only return tasks items assigned to provided id" do
        Task.assigned_to(@user1).count.should == 3
        Task.assigned_to(@user2).count.should == 2
        Task.assigned_to(@user3).count.should == 5
      end

      it "should return all tasks items associated with multiple users when given several ids" do
        Task.assigned_to(@user1, @user2).count.should == 5
        Task.assigned_to(@user1, @user3).count.should == 8
        Task.assigned_to(@user1, @user2, @user3).count.should == 10
      end
    end
  end

  describe 'state machine' do
    it "should default to open state" do
      subject.state.should == "open"
    end

    context 'when state is open' do
      it 'close event should transition to closed state' do
        subject.state = "open"

        subject.close == true
        subject.state.should == "closed"
      end
    end

    context 'when state is completed' do
      it 'reopen event should transition to open state' do
        subject.state = "closed"

        subject.reopen.should == true
        subject.state.should == "open"
      end
    end
  end
end
