module NetworksHelper
  def get_storage_path(dir,file)
    STORAGE + dir + '/' + file
  end

  # FIXME the applet want a path relative to /applet/data (otherwise ActionController::RoutingError)
  def get_storage_path_for_applet(dir, file)
    '../..'+ STORAGE + dir + '/' + file
  end
end
