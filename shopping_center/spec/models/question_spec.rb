require 'spec_helper'

describe Question do
  subject { Factory.build(:question) }

  describe 'validations' do
    it { should validate_presence_of(:question) }
    it { should validate_presence_of(:answer) }
  end

  describe 'associations' do
  end

  describe 'methods' do
  end

  describe 'scopes' do
  end
end
