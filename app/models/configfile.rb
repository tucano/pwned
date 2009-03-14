class Configfile < ActiveRecord::Base
  belongs_to :network

  has_attachment :content_type => ['text/xml', 'application/xml'],
                 :max_size => 1.megabyte,
                 :storage => :file_system, 
                 :path_prefix => "#{STORAGE_PATH_PREFIX}/#{table_name}"

  validate :attachment_valid?

  def attachment_valid?
    
    unless self.filename then
      errors.add(:filename, "no configfile file was selected" )
    end

    content_type = attachment_options[:content_type]
    unless content_type.nil? || content_type.include?(self.content_type) then
      errors.add(:content_type, "configfile error on content-type: #{self.content_type}" )
    end

    size = attachment_options[:size]
    unless size.nil? || size.include?(self.size) then
      errors.add(:size, "configfile error on size #{self.size}")
    end
  end

end
