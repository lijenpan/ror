class ResearchGroupsController < ApplicationController
  load_and_authorize_resource :only => [:new, :edit, :update, :destroy, :create]
  respond_to :html

  def update
    @research_group.research_manager = User.find(params[:research_group][:research_manager]) if !params[:research_group][:research_manager].nil?
    if !params[:researchers].nil?
      @research_group.researchers = []
      params[:researchers].each do |r|
        @research_group.researchers << User.find(r)
      end
    end

    @research_group.update_attributes(:name => params[:research_group][:name])
    flash[:notice] = t(:research_group_updated) if @research_group.save
    respond_with @research_group
  end

  def edit
    @research_group = ResearchGroup.find(params[:id])
    respond_with @research_group
  end

  def new
    @research_group = ResearchGroup.new
    @research_group.researchers.build
    respond_with @research_group
  end

  def create
    if params[:commit] != 'Cancel'
      @research_group.research_manager = User.find(params[:research_group][:research_manager]) if !params[:research_group][:research_manager].nil?
      if !params[:researchers].nil?
        params[:researchers].each do |r|
          @research_group.researchers << User.find(r)
        end
      end
      flash[:notice] = t(:research_group_created) if @research_group.save

      respond_with @research_group
    else
      redirect_back_or_default
    end
  end

  def show
    @research_group = ResearchGroup.find(params[:id])
    respond_with @research_group
  end

  def destroy
    flash[:notice] = t(:research_group_deleted) if @research_group.destroy
    redirect_to current_user.dashboard_path
  end
end
