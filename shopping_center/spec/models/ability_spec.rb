require 'spec_helper'
require 'cancan/matchers'

describe "User" do
  describe "abilities" do
    subject { ability }
    let(:ability) { Ability.new(user) }

    context "when is an administrator" do
      let(:user) { Factory(:admin) }

      it { should be_able_to(:manage, :all) }
      it { should be_able_to(:become, User) }
    end

    context "when is a project manager" do
      let(:user) { Factory(:product_manager) }

      it { should be_able_to(:manage, Message) }
      it { should be_able_to(:manage, Task) }
      it { should be_able_to(:show, User) }
      it { should be_able_to(:create, User)}
      it { should be_able_to(:new, User) }
      it { should be_able_to(:edit, User) }
      it { should be_able_to(:update, User) }
      it { should be_able_to(:destroy, User) }
      it { should be_able_to(:read, ShoppingCenter) }
      it { should be_able_to(:read, Retailer) }
      it { should_not be_able_to(:become, User) }
    end

    context "when is a research manager" do
      let(:user) { Factory(:research_manager) }

      it { should be_able_to(:read, :all) }
      it { should be_able_to(:manage, Message) }

      it { should be_able_to(:update, ShoppingCenter.new(:state => "awaiting_verification")) }
      it { should be_able_to(:edit, ShoppingCenter.new(:state => "awaiting_verification")) }

      it { should be_able_to(:change_state, ShoppingCenter) }
      it { should_not be_able_to(:change_state, ShoppingCenter.new(:state => "researcher_collecting")) }

      it { should be_able_to(:read, Task) }
      it { should be_able_to(:create, Task) }
      it { should be_able_to(:manage, Retailer) }

      it { should be_able_to(:create, CoverageList) }
      it { should be_able_to(:new, CoverageList) }

      it { should be_able_to(:edit, CoverageList) }
      it { should be_able_to(:update, CoverageList) }
      it { should be_able_to(:destroy, CoverageList) }
    end

    context "when is a researcher" do
      let(:user) { Factory(:researcher) }

      it { should be_able_to(:manage, Retailer) }
      it { should be_able_to(:read, ShoppingCenter) }
      it { should be_able_to(:create, ShoppingCenter) }
      it { should be_able_to(:update, ShoppingCenter.new(:state => "awaiting_promotion")) }
      it { should be_able_to(:edit, ShoppingCenter.new(:state => "awaiting_promotion")) }
      it { should be_able_to(:change_state, ShoppingCenter) }
      it { should be_able_to(:read, Task) }
      it { should be_able_to(:read, Message) }
    end
  end
end
