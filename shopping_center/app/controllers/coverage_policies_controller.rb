class CoveragePoliciesController < ApplicationController
  before_filter :load_coverage_list
  respond_to :html, :json

  def new
    @coverage_policy = @coverage_list.policies.build
    respond_with @coverage_policy
  end

  def edit
    @coverage_policy = @coverage_list.policies.find(params[:id])
    respond_with @coverage_policy
  end

  def create
    @coverage_policy = @coverage_list.policies.build(params[:coverage_policy])
    ShoppingCenter::CoverageListService.make_coverage_task(@coverage_list, @coverage_policy)

    flash[:notice] = t(:coverage_policy_created) if @coverage_policy.save
    redirect_to @coverage_list
  end

  def update
    @coverage_policy = @coverage_list.policies.find(params[:id])

    flash[:notice] = t(:coverage_policy_updated) if @coverage_policy.update_attributes(params[:coverage_policy])
    redirect_to @coverage_list
  end

  def destroy
    @coverage_policy = @coverage_list.policies.find(params[:id])
    @coverage_policy.destroy
    redirect_to coverage_list_path(@coverage_list)
  end

  private
  def load_coverage_list
    @coverage_list = CoverageList.find_by_slug(params[:coverage_list_id])
  end
end
