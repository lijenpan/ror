class ResearchManagersController < ApplicationController
  load_and_authorize_resource :only => [:dashboard, :show]
  respond_to :html

  def dashboard
    @tasks = Task.assigned_to(current_user).is?(:open)
    @completed_tasks = Task.assigned_to(current_user).is?(:completed)
    @shopping_centers = ShoppingCenter.verified_by(current_user).waiting_on_research_manager
    @retailers = Retailer.collected_by(current_user)
    @researchers = current_user.researchers
  end

  def show
    @user = ResearchManager.find(params[:id])

    @tasks =  [@user.created_tasks, @user.tasks].flatten
    @shopping_centers = @user.shopping_centers

    respond_with @user do |format|
      format.html { render layout: 'users' }
    end
  end
end
