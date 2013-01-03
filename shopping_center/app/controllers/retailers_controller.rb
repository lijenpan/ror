class RetailersController < ApplicationController
  load_and_authorize_resource :only => [:show, :edit, :update, :destroy, :create, :new]
  respond_to :html, :json

  def search
    @query = params[:q]
    @page = params[:page] || 1

    @results = Array.new
    @results = Retailer.fulltext_search(@query) unless @query.nil?
    @results = Kaminari.paginate_array(@results).page(@page).per(10)
  end

  def show
    @history_tracks = @retailer.history_tracks.group_by(&:created_at).collect do |k, v|
      {:created_at => k, :modifications => v}
    end.sort{|m,n| n[:created_at] <=> m[:created_at]}

    @coverage_information = []
    @snoozes = []
    CoverageList.all.each do |cl|
      cl.tasks.where("retailer_id" => params[:id]).each do |ct|
        @coverage_information << ct.closed_at
        @snoozes << ct.snoozes
      end
    end

    respond_with @retailer
  end

  def new
    @retailer = Retailer.new
    @retailer.sectors = []
    @retailer.collection_instances.build
  end

  def edit
    @retailer.collection_instances.build
  end

  def create
    if params[:commit] != 'Cancel'
      @retailer.initiated_by = current_user
      @retailer.sectors = params[:sectors].split ';' if params[:sectors]

      flash[:notice] = t(:retailer_created) if @retailer.save

      respond_with @retailer
    else
      redirect_back_or_default
    end
  end

  def update
    combined = if(params[:sectors])
      params[:sectors].split(';') || []
    end

    @retailer.attributes = params[:retailer].merge(sectors: combined)

    flash[:notice] = t(:retailer_updated) if @retailer.save

    respond_with @retailer
  end

  def destroy
    @retailer.destroy
    redirect_to current_user.dashboard_path
  end
end
