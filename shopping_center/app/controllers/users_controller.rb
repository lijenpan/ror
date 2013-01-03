class UsersController < ApplicationController
  load_and_authorize_resource :only => [:show, :new, :become]
  respond_to :html

  def become
    sign_in @user, :bypass => true
    redirect_to after_sign_in_path_for(@user)
  end

  def show
    redirect_to send("#{@user.role.to_s}_path", @user)
  end

  def create
    if params[:commit] != 'Cancel'
      @user = params[:user][:role].to_class.create(params[:user])
      flash[:notice] = t(:user_created) if @user.save
      respond_with @user
    else
      redirect_back_or_default
    end
  end

  def new
    respond_with @user, layout: 'application'
  end

  def edit
    @user = params[:role].to_class.find(params[:id])
    render :layout => 'application'
  end

  def update
    @user = User.find(params[:id])
    flash[:notice] = t(:user_updated, :user_role => @user.role.to_s.titleize) if @user.update_attributes(params[@user.role])
    respond_with @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to current_user.dashboard_path
  end
end
