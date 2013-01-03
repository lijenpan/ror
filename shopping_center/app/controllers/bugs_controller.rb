class BugsController < ApplicationController
  respond_to :html, :json, :xml

  def destroy
    @bug = Bug.find(params[:id])
    @bug.destroy

    respond_with @bug
  end

  def index
    @bugs = Bug.all
    respond_with @bugs
  end

  def show
    @bug = Bug.find(params[:id])
    respond_with @bug
  end

  def new
    @bug = Bug.new
    respond_with @bug
  end

  def create
    user_params = { submitted_by: current_user.id.to_s, email: current_user.email }
    @bug = Bug.create(params[:bug].merge(user_params))

    flash[:notice] = t(:bug_created) if @bug.save
    respond_with @bug
  end
end
