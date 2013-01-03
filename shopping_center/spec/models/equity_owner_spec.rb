require 'spec_helper'

describe EquityOwner do
  subject { Factory.build(:equity_owner) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:ownership).greater_than_or_equal_to(0).less_than_or_equal_to(100) }
  end

  describe 'associations' do
    it { should be_embedded_in(:shopping_center) }
  end

  describe 'methods' do
  end

  describe 'scopes' do
  end
end
