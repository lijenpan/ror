module ApplicationHelper
  def to_twitter_type(type)
    case type
    when :alert
      "alert-warning"
    when :error
      "alert-error"
    when :success
      "alert-success"
    else
      type.to_s
    end
  end

  def active_user_dashboard
    if user_signed_in?
      return send(current_user.role.to_s << "_dashboard_path")
    else
      raise t(:no_role_assignment)
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    link_to_function(name, "add_fields(this, \"#{association}\", \"<tr>#{escape_javascript(fields)}</tr>\")")
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def current_link_to *args, &block
    root = args.first
    non = "<li>#{link_to *args, &block}</li>"
    active = "<li class='active'>#{link_to *args, &block}</li>"

    return active.html_safe if request.fullpath == '/' && root == 'home' #catch root route
    return active.html_safe if controller.controller_name.gsub(/_/, ' ') == root
    request.fullpath.split('?').first.humanize.end_with?(root) ? active.html_safe : non.html_safe
  end

  def load_stylesheets
    stylesheets = ["application"]

    if ShoppingCenter::Application::assets.find_asset("#{File.join(controller_name, controller_name)}.css")
      stylesheets << File.join(controller_name, controller_name) #controller specific manifest
    end

    if ShoppingCenter::Application::assets.find_asset("#{File.join(controller_name, action_name)}.css")
      stylesheets << File.join(controller_name, action_name) #specific styles for action
    end

    stylesheets
  end

  def load_javascripts
    javascripts = ["application"]

    if ShoppingCenter::Application::assets.find_asset("#{File.join(controller_name, controller_name)}.js")
      javascripts << File.join(controller_name, controller_name) #controller specific manifest
    end

    if ShoppingCenter::Application::assets.find_asset("#{File.join(controller_name, action_name)}.js")
      javascripts << File.join(controller_name, action_name) #specific styles for action
    end

    javascripts
  end

  def distance_to_expiration_in_words(expiration)
    ret = distance_of_time_in_words(Time.now.to_i, expiration.to_i)
    return "#{ret} ago" if expiration < Time.now
    return ret
  end
end
