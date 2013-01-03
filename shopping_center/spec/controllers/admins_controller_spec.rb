require 'spec_helper'

describe AdminsController do
  before do
    login_admin
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
      @admin = Factory.create(:admin)
      get :show, :id => @admin.id
    end

    it { response.should be_success }
    it { assigns[:user].should_not be_nil }
    it { assigns[:user].should be_kind_of(Admin) }
  end
end
