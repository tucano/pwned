class Annotationfile < ActiveRecord::Base
  belongs_to :network

  has_attachment :content_type => 'text/plain',
                 :max_size => 1.megabyte,
                 :storage => :file_system, 
                 :path_prefix => STORAGE_PATH_PREFIX

  validates_as_attachment

end
