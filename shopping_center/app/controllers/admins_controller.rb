class AdminsController < ApplicationController
  load_and_authorize_resource :only => [:dashboard]

  def dashboard
    @users = User.all
    @research_groups = ResearchGroup.all
    # @shopping_centers = ShoppingCenter.all
  end

  def show
    @user = Admin.find(params[:id])
    render layout: 'users'
  end
end
