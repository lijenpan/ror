require 'spec_helper'

describe ResearchersController do
  describe "GET dashboard" do
    context "invalid user" do
      before do
        login_research_manager
        get :dashboard
      end

      it { should redirect_to(subject.current_user.dashboard_path) }
      it "should get 'Access denied.' message if current user is not a researcher" do
        flash[:error].should eql("Access denied.")
      end
    end

    context "valid user" do
      before do
        login_researcher
        get :dashboard
      end

      it { response.should be_success }
    end
  end

  describe "GET show" do
    before do
      login_researcher

      @researcher = Factory.create(:researcher)
      get :show, :id => @researcher.id
    end

    it { response.should be_success }
    it { assigns[:user].should_not be_nil }
    it { assigns[:user].should be_kind_of(Researcher) }
    it { assigns[:tasks].should_not be_nil }
    it { assigns[:shopping_centers].should_not be_nil }
    it { assigns[:retailers].should_not be_nil }
  end
end
