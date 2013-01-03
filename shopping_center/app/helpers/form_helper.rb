module FormHelper
  def bootstrapped_field(builder, obj, input_type, field, opts={})
    render :partial => 'shared/form_field', :locals => { :builder => builder, :type => input_type, :object => obj, :field => field, :opts => opts}
  end
end
