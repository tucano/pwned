module NetworksHelper
  
  # the applet want a path relative to /applet/data (otherwise ActionController::RoutingError)
  def get_file_path_for_applet(file)
    '../../' + file
  end
  
  def page_title(sep=(': '))
    @page_title ||= [
      controller.controller_name.humanize,
      controller.action_name.humanize
    ] * sep
  end
  
  def content_type(type="text/html;charset=utf-8")
    tag 'meta', :'http-equiv' => 'Content-Type', :content => type
  end

  def info
    info = [
    (tag 'meta', :name => 'copyright', :content => COPYRIGHT),
    (tag 'meta', :name => 'author', :content => AUTHOR),
    (tag 'meta', :name => 'description', :content => DESC)]
  end
  
  def icon
    tag 'link', :rel => "icon", :type => "image/x-icon" ,:href => ICON
  end
  
  def form_title
    @form_title ||= set_form_title
  end
  
  def hidden_div_if(condition, attributes = {})
    if condition then
      attributes["style"] = "display: none"
    end
    attrs = tag_options(attributes.stringify_keys)
    "<div #{attrs}>"
  end
  
  def hidden_div_close
    "</div>"
  end
  
  def rss_button
    @rss_button ||= set_rss_button 
  end
  
  private
  
  def set_rss_button
    rss = url_for(formatted_networks_url(:rss))
    image = image_tag("icon_rss.gif")
    "<a href=#{rss} title=#{rss}>#{image}</a>"
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

  def general_error_msgs(*params)
    objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    "can't be saved for #{count} errors"
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
