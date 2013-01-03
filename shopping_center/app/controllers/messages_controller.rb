class MessagesController < ApplicationController
  load_and_authorize_resource
  respond_to :html

  def show
    respond_with @message
  end

  def create
    @message.author = current_user.id
    flash[:notice] = t(:message_created) if @message.save
    respond_with @message
  end

  def new
    respond_with @message
  end

  def destroy
    @message.destroy
    redirect_to current_user.dashboard_path
  end
end
