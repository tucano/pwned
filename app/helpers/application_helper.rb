# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  
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
  
  def simple_breadcrumb
    bc = String.new
    url = request.path.split('?') #remove extra query string parameters
    levels = url[0].split('/') #break up url into different levels
    bc << "<ul>"
    bc << '<li class="nobullet">You are here:&nbsp;</li>'
    bc << '<li>' << link_to("Home", root_url) << '</li> '
    mylink = "/"
    levels.each_with_index do |level, index|
      unless level.blank? then
        mylink << level << '/'
        bc << "<li>" << link_to(level, mylink) << "</li> "
      end
    end
    bc << "</ul>"
    bc
  end
  
end
