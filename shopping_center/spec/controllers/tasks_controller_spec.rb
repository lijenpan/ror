require 'spec_helper'

describe TasksController do
  before do
    login_admin
  end

  describe "GET show" do
    it "assigns the requested tasks item to @task" do
      task = Factory(:task)
      get :show, id: task
      assigns(:task).should eq(task)
    end

    it "renders the :show view" do
      get :show, id: Factory(:task)
      response.should render_template :show
    end
  end

  describe "GET new" do
    it "assigns a title and description to the new tasks item" do
      get :new
      assigns(:task).title.should be_blank
    end

    it "renders the :new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      subject { Factory.build(:task).attributes }

      it "creates a new tasks item" do
        expect{
          post :create, task: subject
        }.to change(Task, :count).by(1)
      end

      it "redirects to the new tasks item" do
        post :create, task: subject
        response.should redirect_to Task.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new tasks item" do
        expect{
          post :create, task: Factory.attributes_for(:invalid_task)
        }.to_not change(Task, :count)
      end

      it "re-renders the new method" do
        post :create, task: Factory.attributes_for(:invalid_task)
        response.should render_template :new
      end
    end
  end

  describe "PUT update" do
    before :each do
      @task = Factory(:task, title: "blah", description: "test")
    end

    context "valid attributes" do
      it "located the requested @task" do
        put :update, id: @task, task: Factory.attributes_for(:task)
        assigns(:task).should eq(@task)
      end

      it "changes @task's attributes" do
        put :update, id: @task, task: Factory.attributes_for(:task, title: "changed title", description: "changed description", creator: ResearchManager.new)
        @task.reload
        @task.title.should eq("changed title")
        @task.description.should eq("changed description")
      end

      it "redirects to the updated tasks item" do
        put :update, id: @task, task: Factory.attributes_for(:task)
        response.should redirect_to @task
      end
    end

    context "invalid attributes" do
      it "locates the requested @task" do
        put :update, id: @task, task: Factory.attributes_for(:invalid_task)
        assigns(:task).should eq(@task)
      end

      it "does not change @task's attributes" do
        put :update, id: @task, task: Factory.attributes_for(:task, title: nil)
        @task.reload
        @task.title.should_not eq("changed title")
        @task.description.should_not eq("changed description")
      end

      it "re-renders the edit method" do
        put :update, id: @task, task: Factory.attributes_for(:invalid_task)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @task = Factory.create(:task)
    end

    it "deletes the tasks item" do
      expect{
        delete :destroy, id: @task
      }.to change(Task, :count).by(-1)
    end

    it "redirects to current user dashboard" do
      delete :destroy, id: @task
      response.should redirect_to subject.current_user.dashboard_path
    end
  end

  describe "GET set_state" do
    subject { Factory.create(:task) }
    let(:open) { "reopen" }
    let(:close) { "close" }

    it "redirects to current tasks item" do
      get :set_state, id: subject.id, to_state: close
      response.should redirect_to subject
    end

    it 'sets state to close when to_state is close' do
      get :set_state, id: subject.id, to_state: close
      subject.reload
      subject.state.should eq('closed')
    end

    it 'sets state to open whe to_state is reopen' do
      subject.close
      get :set_state, id: subject.id, to_state: open
      subject.reload
      subject.state.should eq('open')
    end
  end
end
