class CoverageListsController < ApplicationController
  load_and_authorize_resource :find_by => :slug
  respond_to :html, :json

  def show
    respond_with @coverage_list
  end

  def new
    if current_user.respond_to?(:research_group)
      @coverage_list = current_user.research_group.coverage_lists.build
      @coverage_list.policies.build
      @coverage_list.tasks.build

      respond_with @coverage_list
    else
      flash[:notice] = "Only research managers can create coverage list."
      redirect_to current_user.dashboard_path
    end
  end

  def edit
    @coverage_list.policies.build if @coverage_list.policies.empty?
    @coverage_list.tasks.build if @coverage_list.tasks.empty?

    respond_with @coverage_list
  end

  def create
    if params[:commit] != 'Cancel'
      @coverage_list = CoverageList.new(params[:coverage_list])

      flash[:notice] = t(:coverage_list_created) if @coverage_list.save
      respond_with @coverage_list
    else
      redirect_back_or_default
    end
  end

  def update
    if !params[:to_be_moved_coverage_list].empty?
      params[:to_be_moved_coverage_list].each do |key,value|
        ShoppingCenter::CoverageListService.transfer_coverage_policy(@coverage_list, CoverageList.find(params[:move_to]), @coverage_list.policies.find(key))
      end
    end
    flash[:notice] = t(:coverage_list_updated) if @coverage_list.update_attributes(params[:coverage_list])
    respond_with @coverage_list
  end

  def destroy
    @coverage_list.destroy
    redirect_to current_user.dashboard_path
  end
end
