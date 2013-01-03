require 'spec_helper'

describe ProductManagersController do
  before do
    login_product_manager
  end

  describe "GET dashboard" do
    context "valid user" do
      before do
        get :dashboard
      end

      it { response.should be_success }
    end

    context "invalid user" do
      before do
        login_research_manager
        get :dashboard
      end

      it { response.should redirect_to(subject.current_user.dashboard_path) }
      it "should get 'Access denied.' message if current user is not a admin" do
        flash[:error].should eql("Access denied.")
      end
    end
  end

  describe "GET show" do
    before do
      @product_manager = Factory.create(:product_manager)
      get :show, :id => @product_manager.id
    end

    it { response.should be_success }
    it { assigns[:user].should_not be_nil }
    it { assigns[:user].should be_kind_of(ProductManager) }
  end
end
