require 'spec_helper'

describe RetailersController do
  before do
    login_admin
  end

  describe "GET show" do
    it "renders the :show view" do
      get :show, id: Factory(:retailer)
      response.should render_template :show
    end
  end

  describe "GET new" do
    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new retailer" do
        expect{
          post :create, retailer: Factory.attributes_for(:retailer)
        }.to change(Retailer, :count).by(1)
      end

      it "redirects to the new retailer" do
        post :create, retailer: Factory.attributes_for(:retailer)
        response.should redirect_to Retailer.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new retailer" do
        expect{
          post :create, retailer: Factory.attributes_for(:invalid_retailer)
        }.to_not change(Retailer, :count)
      end

      it "re-renders the new method" do
        post :create, retailer: Factory.attributes_for(:invalid_retailer)
        response.should render_template :new
      end
    end
  end

  describe "PUT update" do
    before :each do
      @retailer = Factory(:retailer)
    end

    context "valid attributes" do
      it "located the requested @retailer" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:retailer)
        assigns(:retailer).should eq(@retailer)
      end

      it "changes @retailer's name attributes" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:retailer, name: "changed name")
        @retailer.reload
        @retailer.name.should eq("changed name")
      end

      it "updates sectors on sector add" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:retailer), sectors: 'foo;bar;baz'
        @retailer.reload
        @retailer.sectors.should eq(['foo', 'bar', 'baz']);
      end

      it "updates sectors on sector removal" do
        @retailer.update_attributes(sectors: "foo;bar;baz".split(";"))
        put :update, id: @retailer, retailer: Factory.attributes_for(:retailer), sectors: 'foo;baz'
        @retailer.reload
        @retailer.sectors.should eq(['foo', 'baz']);
      end

      it "redirects to the updated retailer" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:retailer)
        response.should redirect_to @retailer
      end
    end

    context "invalid attributes" do
      it "locates the requested @retailer" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:invalid_retailer)
        assigns(:retailer).should eq(@retailer)
      end

      it "does not change @retailer's attributes" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:retailer, name: nil)
        @retailer.reload
        @retailer.name.should_not be_nil
      end

      it "re-renders the edit method" do
        put :update, id: @retailer, retailer: Factory.attributes_for(:invalid_retailer)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @retailer = Factory.create(:retailer)
    end

    it "deletes the tasks item" do
      expect{
        delete :destroy, id: @retailer
      }.to change(Retailer, :count).by(-1)
    end

    it "redirects to retailer user dashboard path" do
      delete :destroy, id: @retailer
      response.should redirect_to subject.current_user.dashboard_path
    end
  end
 end
