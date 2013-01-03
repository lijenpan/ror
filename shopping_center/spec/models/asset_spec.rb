require 'spec_helper'

describe Asset do
  before { @asset = Factory.build(:asset) }
  subject { @asset }

  describe 'validations' do

  end

  describe 'associations' do
    it { should be_embedded_in(:shopping_center) }
  end

  describe 'methods' do

  end

  describe 'scopes' do

  end
end
