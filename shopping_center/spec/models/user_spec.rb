require 'spec_helper'

describe User do
  subject { Factory.build(:user) }

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'associations' do
    it { should have_many(:tasks) }
  end

  describe 'methods' do
    describe '.name' do
      #no tests here because first_name and last_name are validated
      #so they're already assured to not be nil. We could test to make sure different
      #types of names get titleized correctly but I don't really care about that yet.
    end

    describe '.username' do
      #again the majority of the failure cases are assured by the validations
      #and checking the format is not priority right now
    end

    describe '.has_manager?' do
      it "should respond false if user does not respond to manager method"
      it "should respond false if user responds but has nothing assigned to manager method"
    end

    describe '.is?' do
      context '*roles is empty' do
        #perhaps we should throw an error if no values are provided, not sure what rails way is
        it 'should return false' do
          subject.is?.should == false
        end
      end

      context '*roles is not empty' do
        it 'should return true if self.role is found in *roles' do
          subject.is?(:user).should == true
          subject.is?(:role1, :user, :role3).should == true
        end

        it 'should return false if self.role is not found in *roles' do
          subject.is?(:role2, :role3).should == false
        end
      end
    end

    describe '.dashboard_path' do
      it 'should return the dashboard path of the associated role' do
        Factory.build(:researcher).dashboard_path.should eq('/researcher/dashboard')
        Factory.build(:research_manager).dashboard_path.should eq('/research_manager/dashboard')
        Factory.build(:product_manager).dashboard_path.should eq('/product_manager/dashboard')
        Factory.build(:admin).dashboard_path.should eq('/admin/dashboard')
      end
    end
  end
end
