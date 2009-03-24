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
  
end
