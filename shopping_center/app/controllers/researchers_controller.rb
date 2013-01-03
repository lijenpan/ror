class ResearchersController < ApplicationController
  load_and_authorize_resource :only => [:dashboard]
  respond_to :html

  def dashboard
    @tasks = Task.assigned_to(current_user).is?(:open)
    @tasks += current_user.coverage_lists.collect(&:tasks).flatten.select{ |t| t.state == 'open'}
    @tasks.sort!

    @completed_tasks = Task.assigned_to(current_user).is?(:completed)
    @shopping_centers = ShoppingCenter.collected_by(current_user).waiting_on_researcher
    @completed_shopping_centers = ShoppingCenter.where(:researcher_id => current_user.id)
                                                .not_in(:state => ["awaiting_promotion", "researcher_collecting", "error", "incomplete"])
    @retailers = Retailer.collected_by(current_user)

    @index_changes = AWSUtil.list("website_index")
  end

  def show
    @user = Researcher.find(params[:id])
    @tasks = @user.tasks
    @shopping_centers = @user.shopping_centers
    @retailers = Retailer.collected_by(@user)

    respond_with @user, @tasks, @shopping_center, @retailers, layout: 'users'
  end
end
