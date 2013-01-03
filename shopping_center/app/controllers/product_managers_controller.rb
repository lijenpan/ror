class ProductManagersController < ApplicationController
  load_and_authorize_resource :only => [:dashboard]
  respond_to :html

  def dashboard
    @researchers = Researcher.all
    @research_managers = ResearchManager.all
    @research_groups = ResearchGroup.all
    @users = User.all
  end

  def show
    @user = ProductManager.find(params[:id])
    respond_with @user, layout: 'users'
  end
end
