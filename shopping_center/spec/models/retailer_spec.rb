require 'spec_helper'

describe Retailer do
  subject { Factory.build(:retailer) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:primary_sector) }
    it { should validate_presence_of(:initiated) }
    it { should validate_presence_of(:company) }
  end

  describe 'associations' do
    it { should embed_many(:comments) }
    it { should belong_to(:initiated_by) }
    it { should embed_many(:collection_instances) }
  end

  describe 'methods' do
    describe '.keywords' do

      # factory :banana_republic do
      #   name "Banana Republic"
      #   primary_sector "Clothing"
      #   company "Gap Inc."
      #   sectors {["Men's", "Women's", "Casual"]}
      # end
      subject { Factory.build(:banana_republic) }

      it "should include the name field in the keywords list" do
        subject.keywords.include?("Banana").should == true
        subject.keywords.include?("Republic").should == true
      end

      it "should include the primary_sector field in the keywords list" do
        subject.keywords.include?("Clothing").should == true
      end

      it "should include the company name field in the keywords list" do
        subject.keywords.include?("Gap").should == true
        subject.keywords.include?("Inc.").should == true
      end

      it "should include the sectors array in the keywords list" do
        subject.keywords.include?("Mens").should == true
        subject.keywords.include?("Womens").should == true
        subject.keywords.include?("Casual").should == true
      end
    end
  end

  describe 'scopes' do
    describe '#initiated_by' do
      before(:each) do
        @user1 = Factory.create(:user)
        @user2 = Factory.create(:user)
        @user3 = Factory.create(:user)

        3.times { Factory.create(:retailer, initiated_by: @user1 ) }
        2.times { Factory.create(:retailer, initiated_by: @user2 ) }
        5.times { Factory.create(:retailer, initiated_by: @user3 ) }
      end

      it "should return empty array if no users are provided" do
        ret = Retailer.initiated_by
        ret.count.should == 0
        ret.should be_empty
      end

      it "should only return retailers initiated by provided id" do
        Retailer.initiated_by(@user1).count.should == 3
        Retailer.initiated_by(@user2).count.should == 2
        Retailer.initiated_by(@user3).count.should == 5
      end

      it "should return all retailers associated with multiple users when given several ids" do
        Retailer.initiated_by(@user1, @user2).count.should == 5
        Retailer.initiated_by(@user1, @user3).count.should == 8
        Retailer.initiated_by(@user1, @user2, @user3).count.should == 10
      end
    end

    describe '#collected_by' do
      before(:each) do
        @user1 = Factory.create(:user)
        @user2 = Factory.create(:user)
        @user3 = Factory.create(:user)

        @retailer1 = Factory.create(:retailer)
        @retailer2 = Factory.create(:retailer)
        @retailer3 = Factory.create(:retailer)

        Factory.create(:collection_instance, collector: @user2, retailer: @retailer1)
        Factory.create(:collection_instance, collector: @user3, retailer: @retailer1)
        Factory.create(:collection_instance, collector: @user2, retailer: @retailer2)
        Factory.create(:collection_instance, collector: @user2, retailer: @retailer3)
        Factory.create(:collection_instance, collector: @user3, retailer: @retailer3)
      end

      it 'should return empty array if no users are provided' do
        ret = Retailer.collected_by
        ret.count.should == 0
        ret.should be_empty
      end

      it 'should return all retailers that have any collection instances created by provided user' do
        Retailer.collected_by(@user1).should be_empty
        Retailer.collected_by(@user2).count.should eq(3)
        Retailer.collected_by(@user3).count.should eq(2)
      end

      it 'should return all retailers with any collection instances created by list of users' do
        Retailer.collected_by(@user1, @user3).count.should eq(2)
        Retailer.collected_by(@user2, @user3).count.should eq(3)
      end
    end
  end
end
