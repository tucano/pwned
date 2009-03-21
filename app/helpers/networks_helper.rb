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
    xml.root.each_element do |e|
      form  << e.name
      if e.name == "flags" then 
        form << '<dl><dt>' << label(xml.root.name, 'flags') << '</dt><dd>'
        e.each_element do |n|
          form << check_box(xml.root.name, n.name) << label(xml.root.name, n.name, nil, {:class => 'opt'}) << " "
        end
        form << '</dd></dl>'
      else
        e.each_element do |n|
          form  << "<p>" << n.name << "</p>"
          n.each_element do |p|
            mypar = n.name + '_' + p.name
            label = label(xml.root.name, mypar )
            element = text_field(xml.root.name, mypar, :size => 5)
            form << '<dl>'
            form << '<dt>' << label <<  '</dt>'
            form << '<dd>' << element << '</dd>'
            form << '</dl>'
          end
        end
      end
    end
    form
  end
  
end
