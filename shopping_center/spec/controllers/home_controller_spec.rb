require 'spec_helper'

describe HomeController do
  before do
    login_admin
  end

  describe "GET index" do
    it "populates an array of PM messages" do
      message = Factory(:message)
      get :index
      assigns(:pm_messages).should eq([message])
    end
  end

  describe "GET faq" do
    it "populates an array of questions" do
      question = Factory(:question)
      get :faq
      assigns(:questions).should eq([question])
    end
  end
end
