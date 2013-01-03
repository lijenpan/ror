require 'spec_helper'

describe CommentsController do
  before do
    login_admin
  end

  before :each do
    @shopping_center = Factory.create(:shopping_center)
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new comment" do
        expect{
          post :create, shopping_center_id: @shopping_center, comment: Factory.attributes_for(:comment)
          @shopping_center.reload
        }.to change{@shopping_center.comments.count}.by(1)
      end

      it "redirects to the shopping center page" do
        post :create, shopping_center_id: @shopping_center, comment: Factory.attributes_for(:comment)
        response.should redirect_to @shopping_center
      end
    end
  end

  describe "PUT update" do
    context "valid attributes" do
      it "should update the comment with new information" do
        @shopping_center.comments.create(Factory.attributes_for(:comment))
        @shopping_center.reload
        put :update, shopping_center_id: @shopping_center, id: @shopping_center.comments.last, comment: {"body" => "New Comment Body"}
        @shopping_center.reload
        @shopping_center.comments.last.body.should eq("New Comment Body")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @shopping_center.comments.create(Factory.attributes_for(:comment))
    end

    it "deletes the comment" do
      expect{
        delete :destroy, id: @shopping_center.comments.last, shopping_center_id: @shopping_center
        @shopping_center.reload
      }.to change{@shopping_center.comments.count}.by(-1)
    end

    it "redirects to commentable object" do
      delete :destroy, id: @shopping_center.comments.last, shopping_center_id: @shopping_center
      response.should redirect_to @shopping_center
    end
  end
end
