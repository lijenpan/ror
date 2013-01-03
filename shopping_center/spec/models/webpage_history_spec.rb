require 'spec_helper'

describe WebpageHistory do
  subject { Factory.build(:webpage_history) }

  describe 'validations' do
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:body) }
  end
end
