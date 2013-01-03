require 'spec_helper'

describe ResearchGroupsController do
  before do
    login_admin
  end

  before :each do
    @research_group = Factory.create(:research_group)
  end

  describe "PUT update" do
    it "locates the requested research group" do
      put :update, id: @research_group, research_group: Factory.attributes_for(:research_group)
      assigns(:research_group).should eq(@research_group)
    end

    it "changes research group's attributes" do
      put :update, id: @research_group, research_group: Factory.attributes_for(:research_group, name: "new research team")
      @research_group.reload
      @research_group.name.should eq("new research team")
    end

    it "redirects to the updated research group" do
      put :update, id: @research_group, research_group: Factory.attributes_for(:research_group)
      response.should redirect_to @research_group
    end
  end

  describe "GET new" do
    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "GET edit" do
    it "locates the requested research group" do
      get :edit, id: @research_group
      assigns(:research_group).should eq(@research_group)
    end
  end

  describe "POST create" do
    it "creates a new research group" do
      expect {
        post :create, research_group: Factory.attributes_for(:research_group)
      }.to change(ResearchGroup, :count).by(1)
    end

    it "redirects to the new research group" do
      post :create, research_group: Factory.attributes_for(:research_group)
      response.should redirect_to ResearchGroup.last
    end
  end

  describe "DELETE destroy" do
    it "deletes the research group" do
      expect {
        delete :destroy, id: @research_group
      }.to change(ResearchGroup, :count).by(-1)
    end
  end
end
