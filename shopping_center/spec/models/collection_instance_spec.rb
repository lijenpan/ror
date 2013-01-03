require 'spec_helper'

describe CollectionInstance do
  subject { Factory.build(:collection_instance) }

  describe 'validations' do
    it { should validate_presence_of(:collected_on) }

    describe 'harvested' do
      it 'should be invalid when not true or false' do
        subject.should be_valid

        subject.harvested = 't'
        subject.should_not be_valid

        subject.harvested = 123
        subject.should_not be_valid
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:collector) }
    it { should be_embedded_in(:retailer) }
  end

  describe 'methods' do
    describe '.collected_by' do
      it 'should return the name of the collection agent'
    end
  end
end
