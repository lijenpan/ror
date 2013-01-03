require 'spec_helper'

describe ShoppingCentersController do
  before do
    login_admin
  end

  describe "GET new" do
    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new shopping center" do
        expect{
          post :create, shopping_center: Factory.attributes_for(:shopping_center)
        }.to change(ShoppingCenter, :count).by(1)
      end

      it "redirects to the new shopping center" do
        post :create, shopping_center: Factory.attributes_for(:shopping_center)
        response.should redirect_to ShoppingCenter.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new shopping center" do
        expect{
          post :create, shopping_center: Factory.attributes_for(:invalid_shopping_center)
        }.to_not change(ShoppingCenter, :count)
      end

      it "re-renders the new method" do
        post :create, shopping_center: Factory.attributes_for(:invalid_shopping_center)
        response.should render_template :new
      end
    end

    context "with anchor tenants" do
      it "build the anchor tenants on the shopping center" do
        sc = Factory.build(:shopping_center)
        tenants = ["kohls", "gap", "banana republic"]

        tenants.each do |t|
          sc.tenants.build(name: t)
        end

        post :create, shopping_center: Factory.attributes_for(:shopping_center), anchor_tenants: tenants.join(';')

        assigns(:shopping_center).should have(3).tenants
      end
    end
  end

  describe "PUT update" do
    before :each do
      @shopping_center = Factory.create(:shopping_center)
    end

    context "valid attributes" do
      it "located the requested @shopping_center" do
        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:shopping_center)
        assigns(:shopping_center).should eq(@shopping_center)
      end

      it "changes @shopping_center's attributes" do
        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:shopping_center, name: "new name")
        @shopping_center.reload
        @shopping_center.name.should eq("new name")
      end

      it "redirects to the updated shopping center" do
        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:shopping_center)
        response.should redirect_to @shopping_center
      end
    end

    context "invalid attributes" do
      it "locates the requested @shopping_center" do
        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:invalid_shopping_center)
        assigns(:shopping_center).should eq(@shopping_center)
      end

      it "does not change @shopping_center's attributes" do
        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:shopping_center, name: nil)
        @shopping_center.reload
        @shopping_center.name.should_not be_nil
      end

      it "re-renders the edit method" do
        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:invalid_shopping_center)
        response.should render_template :edit
      end
    end

    context "with tenants" do
      it "build the tenants on the shopping center" do
        sc = Factory.build(:shopping_center)
        tenants = ["kohls", "gap", "banana republic"]

        tenants.each do |t|
          sc.tenants.build(name: t)
        end

        put :update, id: @shopping_center, shopping_center: Factory.attributes_for(:shopping_center), tenants: tenants.join(';')
        assigns(:shopping_center).should have(3).tenants
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @shopping_center = Factory.create(:shopping_center)
    end

    it "deletes the shopping center" do
      expect{
        delete :destroy, id: @shopping_center
      }.to change(ShoppingCenter, :count).by(-1)
    end

    it "redirects to home page" do
      delete :destroy, id: @shopping_center
      response.should redirect_to home_path
    end
  end
end
