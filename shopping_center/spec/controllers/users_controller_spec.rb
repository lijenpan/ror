require 'spec_helper'

describe UsersController do
  before do
    login_admin
  end

  describe "GET show" do
    it "should always redirect if accessed"
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new user" do
        expect{
          post :create, user: Factory.attributes_for(:user).merge( role: :user )
        }.to change(User, :count).by(1)
      end

      it "redirects to the new user" do
        post :create, user: Factory.attributes_for(:user).merge( role: :user )
        response.should redirect_to User.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new user" do
        expect{
          post :create, user: Factory.attributes_for(:invalid_user).merge( role: :user )
        }.to_not change(User, :count)
      end

      it "re-renders the new method" do
        post :create, user: Factory.attributes_for(:invalid_user).merge( role: :user )
        response.should render_template :new
      end
    end
  end

  describe "PUT update" do
    before :each do
      @user = Factory(:user)
    end

    context "valid attributes" do
      it "located the requested @user" do
        put :update, id: @user, user: Factory.attributes_for(:user), role: :user
        assigns(:user).should eq(@user)
      end

      it "changes @user's attributes" do
        put :update, id: @user, user: Factory.attributes_for(:user, first_name: "changed first name"), role: :user
        @user.reload
        @user.first_name.should eq("changed first name")
      end

      it "redirects to the updated user" do
        put :update, id: @user, user: Factory.attributes_for(:user), role: :user
        response.should redirect_to @user
      end
    end

    context "invalid attributes" do
      it "locates the requested @user" do
        put :update, id: @user, user: Factory.attributes_for(:invalid_user), role: :user
        assigns(:user).should eq(@user)
      end

      it "does not change @user's attributes" do
        put :update, id: @user, user: Factory.attributes_for(:user, email: nil), role: :user
        @user.reload
        @user.email.should_not be_nil
      end

      it "re-renders the edit method" do
        put :update, id: @user, user: Factory.attributes_for(:invalid_user), role: :user
        response.should render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @user = Factory.create(:user)
    end

    it "deletes the user" do
      expect{
        delete :destroy, id: @user, role: :user
      }.to change(User, :count).by(-1)
    end

    it "redirects to dashboard page" do
      delete :destroy, id: @user, role: :user
      response.should redirect_to subject.current_user.dashboard_path
    end
  end

  describe "GET new" do
    before(:each) do
      get :new
    end

    it { response.should render_template :new }
    it { response.should be_success }
  end

  describe 'GET become' do
    before do
      @researcher = Factory.create(:researcher)
    end

    it "should allow admins to access the feature" do
      login_admin
      get :become, id: @researcher

      flash[:error].should be_nil
      response.should redirect_to @researcher.dashboard_path
    end

    it "shouldn't allow non-admin users to become other users" do
      product_manager = login_product_manager
      get :become, id: @researcher

      flash[:error].should =~ /Access denied/i
      subject.current_user.should eq(product_manager)
      response.should redirect_to product_manager.dashboard_path
    end
  end
end
