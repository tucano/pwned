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
    (tag 'meta', :name => 'copyright', :content => "Creative Commons License"),
    (tag 'meta', :name => 'author', :content => "Tucano"),
    (tag 'meta', :name => 'description', :content => "Network data drawer")]
  end
  
  def icon
    tag 'link', :rel => "icon", :type => "image/x-icon" ,:href => "/images/favicon.ico"
  end
  
end
