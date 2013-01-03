require 'spec_helper'

describe Tenant do
  subject { Factory.build(:tenant) }

  describe 'validations' do
    it { should validate_presence_of(:name) }

    describe 'is_anchor' do
      it { should allow_value(true).for(:is_anchor) }
      it { should allow_value(false).for(:is_anchor) }

      it 'should default to false' do
        Factory.build(:tenant, is_anchor: true).is_anchor.should == true
        Factory.build(:tenant).is_anchor.should == false
      end

      it "shouldn't be valid for non boolean values" do
        Factory.build(:tenant, is_anchor: "yes").should_not be_valid
        Factory.build(:tenant, is_anchor: "no").should_not be_valid
      end
    end

  end

  describe 'associations' do
    it { should be_embedded_in(:shopping_center) }
  end

  describe 'methods' do
    describe 'anchor?' do
      it 'should mimick a call to the [is_anchor] field' do
        subject.is_anchor.should == subject.anchor?
        subject.is_anchor = !subject.is_anchor
        subject.is_anchor.should == subject.anchor?
      end
    end
  end

  describe 'scope' do
  end
end
