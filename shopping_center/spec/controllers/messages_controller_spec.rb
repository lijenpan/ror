require 'spec_helper'

describe MessagesController do
  before do
    login_admin
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new message" do
        expect{
          post :create, message: Factory.attributes_for(:message)
        }.to change(Message, :count).by(1)
      end

      it "redirects to the new Message" do
        post :create, message: Factory.attributes_for(:message)
        response.should redirect_to Message.last
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @message = Factory.create(:message)
    end

    it "deletes the tasks item" do
      expect{
        delete :destroy, id: @message
      }.to change(Message, :count).by(-1)
    end

    it "redirects to dashboard page" do
      delete :destroy, id: @message
      response.should redirect_to subject.current_user.dashboard_path
    end
  end

  describe "GET show" do
    it "assigns the request message to @message" do
      message = Factory(:message)
      get :show, id: message
      assigns(:message).should eq(message)
    end

    it "renders the :show view" do
      get :show, id: Factory(:message)
      response.should render_template :show
    end
  end

  describe "GET new" do
    context "valid user" do
      before do
        get :new
      end

      it { response.should render_template :new }
    end

    context "invalid user" do
      before do
        login_researcher
        get :new
      end

      it { response.should redirect_to subject.current_user.dashboard_path }
    end
  end
end
