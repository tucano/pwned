class Fileservice

  attr_reader :network, :edgefile, :configfile, :annotationfile

  def initialize(network, edgefile, configfile, annotationfile)
    # if empty a file upload is: #<Annotationfile id: nil, network_id: nil, filename: nil, content_type: nil, size: nil, created_at: nil, updated_at: nil>
    @network = network
    @edgefile = edgefile
    @configfile = configfile
    @annotationfile = annotationfile
  end

  def save
    return false unless valid?
    begin 
      Network.transaction do
        check_edges()
        check_config()
        check_annotation() if has_annotation?
        @network.save!
      end
    rescue
      false
    end
  end

  def valid?
    
    # I need assignments to have errors back (short-circuit operators in ruby)
    n = @network.valid?
    c = @configfile.valid?
    e = @edgefile.valid?
    a = true
    if has_annotation? then 
      a = @annotationfile.valid? 
    end
    
    if (n && c && e && a) then
      return true
    else
      return false
    end
  end
  
  def has_annotation?
    !@annotationfile.nil? && @annotationfile.attribute_present?(:filename) 
  end

  def update_attributes(network, edgefile, configfile, annotationfile)
    @network.attributes = network
    unless edgefile.nil? || edgefile[:uploaded_data].blank? then
      @edgefile = Edgefile.new(edgefile)
    end
    unless configfile.nil? || configfile[:uploaded_data].blank? then
      @configfile = Configfile.new(configfile)
    end
    unless annotationfile.nil? || annotationfile[:uploaded_data].blank? then
      @annotationfile = Annotationfile.new(annotationfile)
    end
    save
  end

  private
  
  def check_edges
    if @edgefile.new_record? then
      @network.edgefile.destroy if @network.edgefile
      @edgefile.network = @network
      @edgefile.save!
    end
  end

  def check_config
    if @configfile.new_record? then
      @network.configfile.destroy if @network.configfile
      @configfile.network = @network
      @configfile.save!
    end
  end

  def check_annotation
    if @annotationfile.new_record? then
      @network.annotationfile.destroy if @network.annotationfile
      @annotationfile.network = @network
      @annotationfile.save!
    end
  end
  
end
