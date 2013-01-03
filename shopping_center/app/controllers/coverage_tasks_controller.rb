class CoverageTasksController < ApplicationController
  before_filter :load_coverage_list
  respond_to :html, :json

  def close
    @task = @coverage_list.tasks.find(params[:coverage_task_id])
    @task.closed_at << [Time.now.utc, current_user.id]
    @task.save
    @task.update_attributes(:due_date => (Time.now.utc + @task.policy.expiration_duration.minutes))
    redirect_to current_user.dashboard_path
  end

  def snooze
    @task = @coverage_list.tasks.find(params[:coverage_task_id])
    @task.snoozes << (Time.now + 1.day)
    @task.save

    redirect_to current_user.dashboard_path
  end

  def show
    @task = @coverage_list.tasks.find(params[:id])

    respond_with @task
  end

  # def destroy

  # end

  # def create
  #   @coverage_task = @coverage_list.tasks.build(params[:coverage_task])
  #   ShoppingCenter::CoverageListService.make_coverage_task(@coverage_list, @coverage_task)

  #   flash[:notice] = 'Coverage task was successfully created.' if @coverage_task.save
  #   redirect_to @coverage_list
  # end

  # def destroy
  #   @coverage_task = @coverage_list.tasks.find(params[:id])
  #   @coverage_task.destroy
  #   redirect_to coverage_list_path(@coverage_list)
  # end

  private
  def load_coverage_list
    @coverage_list = CoverageList.find_by_slug(params[:coverage_list_id])
  end
end
