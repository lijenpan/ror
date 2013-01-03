require 'spec_helper'

describe Bug do
  before do
    @bug = Factory.build(:bug)
  end

  subject { @bug }

  describe 'validations' do
    it { should validate_presence_of(:submitted_by) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:severity) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
  end

  describe 'methods' do
  end

  describe 'scopes' do
  end
end
