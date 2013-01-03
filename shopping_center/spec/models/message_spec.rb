require 'spec_helper'

describe Message do
  before { @message = Factory.build(:message) }
  subject { @message }

  describe 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:author) }
  end

  describe 'associations' do
  end

  describe 'methods' do
  end

  describe 'scopes' do
  end
end
