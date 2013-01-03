class UnlocksController < Devise::UnlocksController
  skip_before_filter :require_no_authentication

  def new
    super
  end

  def create
    super
  end

  def show
    if !current_user.nil? and current_user.is? :admin
      self.resource = resource_class.unlock_access_by_token(params[:unlock_token])

      if resource.errors.empty?
        set_flash_message :notice, :unlocked if is_navigational_format?
        respond_with_navigational(resource){ redirect_to admin_dashboard_path }
      else
        respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
      end
    else
      set_flash_message :notice, :unauthenticated
      respond_with_navigational(resource, :status => :unprocessable_entity) { redirect_to home_path }
    end
  end
end
