class TasksController < ApplicationController
  load_and_authorize_resource :only => [:show, :edit, :update, :destroy, :create, :new]
  respond_to :html

  def show
  end

  def new
    @users = assignee_options
    render layout: 'application'
  end

  def edit
    @users = assignee_options
    render layout: 'application'
  end

  def create
    if params[:commit] != 'Cancel'
      @users = assignee_options
      @task.creator = current_user
      flash[:notice] = t(:task_created) if @task.save
      respond_with @task
    else
      redirect_back_or_default
    end
  end

  def update
    flash[:notice] = t(:task_updated) if @task.update_attributes(params[:task])
    respond_with @task
  end

  def destroy
    @task.destroy
    redirect_to current_user.dashboard_path
  end

  def set_state
    @task = Task.find(params[:id])

    e = params[:to_state]
    @task.send(params[:to_state])

    redirect_to task_path(@task)
  end

  private
  def assignee_options
    (current_user.is? :research_manager) ? current_user.researchers : Researcher.all.to_a.concat(ResearchManager.all)
  end
end
