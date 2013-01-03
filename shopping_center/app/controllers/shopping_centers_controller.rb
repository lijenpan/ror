class ShoppingCentersController < ApplicationController
  load_and_authorize_resource :only => [:show, :edit, :update, :destroy, :create, :new]
  respond_to :html, :json

  def search
    @query = params[:q]
    @page = params[:page] || 1

    @results = Array.new
    # @results = ShoppingCenter.fulltext_search(@query, :searchable => true) unless @query.nil?
    # now we want to make everything searchable even if they are not verified.
    @top_result = ShoppingCenter.fulltext_search(@query, :index => 'shopping_center_name_index', :max_results => 1)
    @fuzzy_results = ShoppingCenter.fulltext_search(@query, :index => 'shopping_center_full_index')

    if !@top_result.empty?
      if @fuzzy_results.include? @top_result[0]
        @results << @top_result[0]
        @fuzzy_results.each do |fr|
          @results << fr if fr != @top_result[0]
        end
      else
        @results = @top_result.zip(@fuzzy_results).flatten.compact
      end
    else
      @results = @fuzzy_results
    end
    @results = Kaminari.paginate_array(@results).page(@page).per(10)

    respond_with(@results, :layout => 'application')
  end

  def show
    @history_tracks = @shopping_center.history_tracks.group_by(&:created_at).collect do |k, v|
      {:created_at => k, :modifications => v}
    end.sort{|m,n| n[:created_at] <=> m[:created_at]}

    respond_with @shopping_center
  end

  def edit
    @shopping_center.equity_owners.build
    @shopping_center.assets.build

    respond_with @shopping_center
  end

  def create
    if params[:commit] != 'Cancel'
      @shopping_center.researcher = current_user
      @shopping_center.research_manager = current_user.manager if current_user.has_manager?

      #ajax form elements processed differently
      anchors = params[:anchor_tenants] || ""
      tenants = params[:tenants] || ""

      add_tenants(@shopping_center, anchors.split(';'), true)
      add_tenants(@shopping_center, tenants.split(';'), false)

      if @shopping_center.save
        flash[:notice] = t(:shopping_center_created)
        @shopping_center.scsm_save
      end

      respond_with @shopping_center
    else
      redirect_back_or_default
    end
  end

  def update
    assets = params[:shopping_center][:assets_attributes] || []
    assets.each do |a|
      if a[1][:_destroy] == "1"
        ShoppingCenter.find(params[:id]).assets.find(a[1][:id]).destroy
      end
    end

    @shopping_center.update_attributes(params[:shopping_center])

    #ajax form elements processed differently
    anchors = params[:anchor_tenants] || ""
    tenants = params[:tenants] || ""
    assets = params[:shopping_center][:assets_attributes] || []

    @shopping_center.tenants.select{|t| t.is_anchor == true and not anchors.split(';').include? t.name}.each do |t|
      t.destroy
    end

    @shopping_center.tenants.select{|t| t.is_anchor == false and not tenants.split(';').include? t.name}.each do |t|
      t.destroy
    end

    add_tenants(@shopping_center, anchors.split(';'), true)
    add_tenants(@shopping_center, tenants.split(';'), false)

    if @shopping_center.save
      flash[:notice] = t(:shopping_center_updated)
      @shopping_center.scsm_save
    end

    respond_with @shopping_center
  end

  def destroy
    @shopping_center.destroy
    redirect_to home_path
  end

  def new
    @shopping_center = ShoppingCenter.new
    @shopping_center.build_address
    @shopping_center.tenants.build
    @shopping_center.equity_owners.build
    @shopping_center.assets.build

    respond_with @shopping_center
  end

  def set_state
    @shopping_center = ShoppingCenter.find(params[:id])

    e = params[:to_state]
    @shopping_center.send(params[:to_state])
    to = @shopping_center.state


    if(e.to_sym == :scsm_edit)
      redirect_to edit_shopping_center_path(@shopping_center)
    else
      redirect_to shopping_center_path(@shopping_center)
    end
  end

  private
  def add_tenants(shopping_center, tenant_names, anchor=false)
    tenant_names.each do |n|
      shopping_center.tenants.build(is_anchor: anchor, name: n) if !@shopping_center.has_tenant?(n)
    end
  end
end
