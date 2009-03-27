module NetworksHelper
  
  # the applet want a path relative to /applet/data (otherwise ActionController::RoutingError)
  def get_file_path_for_applet(file)
    '../../../' + file
  end
    
  def form_title
    @form_title ||= set_form_title
  end
  
  def general_error_msgs(*params)
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    errors = String.new
    errors << "<h2>Network can't be saved for #{count} errors</h2>"
    errors << '<p>There were problems with the following objects</p>'
    errors << '<ul>'
    objects.each do |obj|
      unless obj.errors.empty?
        errors << '<li>' << obj.class.name
        errors << '<ul>'
        obj.errors.full_messages.each do |msg|
          errors << '<li class="child">' << msg << '</li>'
        end
        errors << '</li>'
        errors << '</ul>'
      end
    end
    errors << '</ul>'
    errors
  end
  
  def set_form_title
    if controller.action_name == 'new'
      "New #{controller.controller_name.singularize}"
    elsif controller.action_name == 'edit'
      "Editing #{@network.name}"
    else
      "New Form"
    end
  end

 
  
  def config_form_builder(xml)
    form = String.new
    xmlparams = xml.root.elements[1]
    xmlcolors = xml.root.elements[2]
    xmlflags  = xml.root.elements[3]
    
    form << '<fieldset class="child"><legend class="child">params</legend>'
    fields_for(xmlparams.name) do |par|
      xmlparams.each_element do |p|
        form << '<dl>'      
        form << '<dt>' << label(p.name, p.name) << '</dt>'
        form << '<dd><table><tr>'
        p.each_element do |n|
          mykey = p.name + '_' + n.name
          form << '<td>'
          form << par.label(mykey, n.name) << '</td><td>'
          form << par.text_field(mykey, :size => 5, :value => n.text)
          form << '</td>'
        end
        form << '</tr></table></dd>'
        form << '</dl>'
      end
    form << '</fieldset>'
    end
    
    form << '<fieldset class="child"><legend class="child">colors</legend>'
    fields_for(xmlcolors.name) do |par|
      xmlcolors.each_element do |p|
        form << '<dl>'
        form << '<dt>' << label(p.name, p.name) << '</dt>'
        form << '<dd><table class="niceform"><tr>'
        p.each_element do |n|
          form << '<td>'
          mykey = p.name + '_' + n.name
          form << par.label(mykey, n.name) << '</td><td>'
          form << par.text_field(mykey, :size => 5, :value => n.text)
          form << '</td>'
        end
        form << '</tr></table></dd>'
        form << '</dl>'
        form << '</dl>'
      end
    form << '</fieldset>'
    end
    
    form << '<fieldset class="child"><legend class="child">flags</legend>'
    fields_for(xmlflags.name) do |par|
      xmlflags.each_element do |p|
        checked = false
        checked = true if p.text.to_i > 0
        form << '<dl>'
        form << '<dt>' << par.label(p.name) << '</dt>'
        form << '<dd>' << par.check_box(p.name, :checked => checked) << '</dd>' 
        form << '</dl>'
      end
    end
    form << '</fieldset>'
    return form
  end  
end
