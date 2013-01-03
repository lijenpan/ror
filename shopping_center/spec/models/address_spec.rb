require 'spec_helper'

describe Address do
  subject { Factory.build(:address) }

  describe 'validations' do
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:municipality) }
    it { should validate_presence_of(:governing_district) }
    it { should validate_length_of(:governing_district).is(2) }
    it { should validate_presence_of(:postal_code) }

    describe 'governing_district' do
      it 'should be invalid when it is not 2 characters' do
        subject.governing_district = 'T'
        subject.should_not be_valid

        subject.governing_district = 'TEX'
        subject.should_not be_valid
      end

      it 'should be valid when it is 2 characters' do
        subject.governing_district = 'TX'
        subject.should be_valid
      end
    end
  end

  describe 'associations' do
    it { should be_embedded_in(:shopping_center).as_inverse_of(:address) }
  end

  describe '.to_s' do
    let(:street_number)  { subject.street_number }
    let(:street) { subject.street }
    let(:municipality) { subject.municipality }
    let(:governing_district) { subject.governing_district }
    let(:postal_code) { subject.postal_code }

    context 'when format is not given' do
      it { subject.to_s.should == subject.to_s(:long) }
    end

    context 'when format is :short' do
      it "should only produce the 'municipality, governing_district'" do
        addr = "#{municipality}, #{governing_district}"
        subject.to_s(:short).should == addr
      end
    end

    context 'when format is :long' do
      it 'should produce a full form single line address' do
        addr = "#{street_number} #{street} #{municipality}, #{governing_district} #{postal_code}"
        subject.to_s(:long).should == addr
      end
    end

    context 'when format is :postal' do
      it "should produce the canoncial postal address" do
        addr = [[street_number, street],
          [municipality, governing_district, postal_code]]
        addr = addr.collect{|inner| inner.join(' ')}.join("\n")

        subject.to_s(:postal).should == addr
      end
    end
  end
end
