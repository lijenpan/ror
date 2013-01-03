class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t(:access_denied)
    redirect_to (current_user ? current_user.dashboard_path : home_path)
  end

  #this method overwrites a DEVISE method, do not change the name
  def after_sign_in_path_for(user)
    if not user.role.nil?
      return send(user.role.to_s << "_dashboard_path")
    else
      raise t(:no_role_assignment)
    end
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :error_500
    rescue_from Mongoid::Errors::DocumentNotFound, :with => :error_404
    rescue_from ActionController::RoutingError, :with => :error_404
    rescue_from AbstractController::ActionNotFound, :with => :error_404
  end

  private
  def error_404(exception)
    @message = exception.message
    @trace = exception.backtrace[0...10].join "\n"
    render "/errors/error_404", :status => 404, :layout => 'application'
  end

  def error_500(exception)
    @message = exception.message
    @trace = exception.backtrace[0...10].join "\n"
    render "/errors/error_500", :status => 500, :layout => 'application'
  end

  def redirect_back_or_default(default = nil)
    redirect_to(current_user.dashboard_path || default)
  end
end
