class Configfile < ActiveRecord::Base
  belongs_to :network

  has_attachment :content_type => ['text/xml', 'application/xml'],
                 :max_size => 1.megabyte,
                 :storage => :file_system, 
                 :path_prefix => "#{STORAGE_PATH_PREFIX}/#{table_name}"

  validates_presence_of :filename
  validate :attachment_valid?, :if =>  Proc.new { |c| !c.filename.blank? }
  validate :xml_valid?, :if => Proc.new { |c| !c.temp_data.blank? }

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

  def xml_valid?
    # this validate tags consistency but not <UNDEFINED..>
    begin 
      xml = REXML::Document.new(self.temp_data)
    rescue REXML::ParseException => ex
      errors.add(:xmldata, "is not valid xml. #{ex.continued_exception}")
    end

    # check if
    unless xml.nil? || xml.has_elements? then
      errors.add(:xmldata, "is xml without elements.")
    end

  end

end
