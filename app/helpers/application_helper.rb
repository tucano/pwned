# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper
  
  def time_ago(time)
    mtime = String.new
    mtime << time_ago_in_words(Time.now - (Time.now.to_i - time.to_i).seconds) << " ago"
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
    network_id = false
    levels.each_with_index do |level, index|
      unless level.blank? then
        # FIXME hack for network :id
        mylink << level << '/'
        if network_id then
          level = @network.name if @network
          network_id = false
        end
        bc << "<li>" << link_to(level, mylink) << "</li> "
        network_id = true if level == 'networks'
      end
    end
    bc << "</ul>"
    bc
  end
  
end
