module NetworksHelper
  # FIXME the applet want a path relative to /applet/data (otherwise ActionController::RoutingError)
  def get_file_path_for_applet(file)
    '../../' + file
  end
end
