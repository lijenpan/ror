require 'spec_helper'

describe WaterSamples do
  describe 'validate' do
    let(:sample) { WaterSamples.find(2) }

    describe 'find' do
      it 'should find water sample ID 2' do
        sample.site.should == "North Hollywood Pump Station (well blend)"
        sample.chloroform.should == 0.00291
        sample.bromoform.should == 0.00487
        sample.bromodichloromethane.should == 0.00547
        sample.dibromichloromethane.should == 0.0109
      end
    end

    describe 'factor' do
      it 'should equal to 0.024007 for water sample ID 2 and factor weight ID 1' do
        sample.factor(1).should == 0.024007
      end
    end
  end

  describe 'validate to_hash' do
    let(:sample) { WaterSamples.find(3) }

    it 'should only include water sample by default' do
      hash = sample.to_hash
      hash.should have_key :id
      hash.should have_key :site
      hash.should have_key :chloroform
      hash.should have_key :bromoform
      hash.should have_key :bromodichloromethane
      hash.should have_key :dibromichloromethane
    end

    it 'should include factor weights when passing in true as the parameter' do
      hash = sample.to_hash(true)
      hash.should have_key :id
      hash.should have_key :site
      hash.should have_key :chloroform
      hash.should have_key :bromoform
      hash.should have_key :bromodichloromethane
      hash.should have_key :dibromichloromethane
      hash.should have_key :factor_1
    end
  end
end
