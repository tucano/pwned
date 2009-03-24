class Edgefile < ActiveRecord::Base
  belongs_to :network

  has_attachment :content_type => 'text/plain',
                 :max_size => 1.megabyte,
                 :storage => :file_system, 
                 :path_prefix => "#{STORAGE_PATH_PREFIX}/#{table_name}"
                 
  validates_presence_of :filename
  validate :attachment_valid?, :if =>  Proc.new { |e| !e.filename.blank? }
  validate :edgefile_valid?, :if => Proc.new { |c| !c.temp_data.blank? }

  def attachment_valid?

    content_type = attachment_options[:content_type]
    unless content_type.nil? || content_type.include?(self.content_type) then
      errors.add(:content_type, "error on content-type: #{self.content_type}" )
    end

    size = attachment_options[:size]
    unless size.nil? || size.include?(self.size) then
      errors.add(:size, "error on size #{self.size}")
    end
  end

  def edgefile_valid?
    # TODO error messages
    edgeservice = Edgeservice.new(self.temp_data)
    unless edgeservice.valid? then
      errors.add(:edgedata, "is not a valid edges file")
    end
  end
  
end
