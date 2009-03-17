class Annotationfile < ActiveRecord::Base
  belongs_to :network

  has_attachment :content_type => 'text/plain',
                 :max_size => 1.megabyte,
                 :storage => :file_system, 
                 :path_prefix => "#{STORAGE_PATH_PREFIX}/#{table_name}"

  validates_presence_of :filename
  validate :attachment_valid?, :if =>  Proc.new { |a| !a.filename.blank? }

  def attachment_valid?

    content_type = attachment_options[:content_type]
    unless content_type.nil? || content_type.include?(self.content_type) then
      errors.add(:content_type,"annotationfile error on content-type: #{self.content_type}" )
    end

    size = attachment_options[:size]
    unless size.nil? || size.include?(self.size) then
      errors.add(:size, "annotationfile error on size #{self.size}")
    end
  end

end
