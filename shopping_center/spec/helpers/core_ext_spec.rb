require 'spec_helper'

describe "String" do
  describe '.to_class' do
    it 'converts a string to a class constant' do
      'string'.to_class.class.should eq(Class)
    end

    it 'camelizes an underscored string' do
      'shopping_center'.to_class.should eq(ShoppingCenter)
    end
  end
end
