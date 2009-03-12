class Configfile < ActiveRecord::Base
  has_one :network

  has_attachment :content_type => 'text/xml',
                 :max_size => 1.megabyte,
                 :storage => :file_system, 
                 :path_prefix => "#{STORAGE_PATH_PREFIX}/#{table_name}"

  validates_as_attachment

end
