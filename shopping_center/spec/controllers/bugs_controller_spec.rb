require 'spec_helper'

describe BugsController do
  before do
    login_admin
  end

  describe "GET index" do
    subject { Factory.create(:bug) }
    before do
      get :index
    end

    it { assigns(:bugs).should eq([subject]) }
    it { response.should render_template :index }
  end

  describe "GET show" do
    subject { Factory.create(:bug) }
    before do
      get :show, id: subject
    end

    it { assigns(:bug).should eq(subject) }
    it { response.should render_template :show }
  end

  describe "GET new" do
    before do
      get :new
    end

    it { assigns(:bug).description.should be_blank }
    it { response.should render_template :new }
  end

  describe "POST create" do
    context "with valid attributes" do
      let(:bug_attrs) { Factory.attributes_for(:bug) }
      before :each do
        post :create, bug: bug_attrs
      end

      it "creates a new bug" do
        expect{
          post :create, bug: bug_attrs
        }.to change(Bug, :count).by(1)
      end

      it { response.should redirect_to Bug.last }
      it { Bug.last.submitted_by.should eq(controller.current_user.id.to_s) }
      it { Bug.last.email.should eq(controller.current_user.email) }
    end

    context "with invalid attributes" do
      let(:bug_attrs) { Factory.attributes_for(:invalid_bug) }

      it "does not save the new bug" do
        expect{
          post :create, bug: bug_attrs
        }.to_not change(Bug, :count)
      end

      it "re-renders the new method" do
        post :create, bug: bug_attrs
        response.should render_template :new
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @bug = Factory.create(:bug)
    end
    subject { @bug }

    it "deletes the bug" do
      expect{
        delete :destroy, id: subject
      }.to change(Bug, :count).by(-1)
    end

    it "redirects to bug :index" do
      delete :destroy, id: subject
      response.should redirect_to bugs_path
    end
  end
end
