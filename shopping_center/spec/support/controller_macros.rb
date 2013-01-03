module ControllerMacros
  def login_admin(admin = Factory.create(:admin))
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
    admin
  end

  def login_user(user = Factory.create(:user))
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    user
  end

  def login_product_manager(product_manager = Factory.create(:product_manager))
    @request.env["devise.mapping"] = Devise.mappings[:product_manager]
    sign_in product_manager
    product_manager
  end

  def login_researcher(researcher = Factory.create(:researcher))
    @request.env["devise.mapping"] = Devise.mappings[:researcher]
    sign_in researcher
    researcher
  end

  def login_research_manager(research_manager = Factory.create(:research_manager))
    @request.env["devise.mapping"] = Devise.mappings[:research_manager]
    sign_in research_manager
    research_manager
  end
end
