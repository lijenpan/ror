require 'spec_helper'

describe Comment do
  subject { Factory.build(:comment) }

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author) }
  end

  describe 'associations' do
    it { should be_embedded_in(:commentable) }
  end

  describe 'methods' do
  end

  describe 'scopes' do
  end
end
