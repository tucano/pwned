class Fileservice

  attr_reader :network, :edgefile, :configfile, :annotationfile, :config_templates, :template_keys

  def initialize(network, edgefile = nil, configfile = nil, annotationfile = nil)
    @network = network
    @edgefile = edgefile
    @configfile = configfile
    @annotationfile = annotationfile
    @config_templates = get_config_templates
    @template_keys = @config_templates.keys
  end

  def save
    return false unless valid?
    begin 
      Network.transaction do
        save_edges()
        save_config()
        save_annotation() if has_annotation?
        @network.save!
      end
    rescue
      false
    end
  end

  def valid?
    
    # I need assignments to have errors back:
    # errors are checked on valid? + short-circuit operators in ruby
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

  def update_attributes(params)
    @network.attributes = params['network']
    edgefile = create_edges(params)
    configfile = create_config(params)
    annotationfile = create_annotation(params)
    unless edgefile.nil? || !edgefile.valid? then
      @edgefile = edgefile
    end
    unless configfile.nil? || !configfile.valid? then
      @configfile = configfile
    end
    unless annotationfile.nil? || !annotationfile.valid? then
      @annotationfile = annotationfile
    end
    save
  end

  def create_files(params)
    
    # TODO before fileservice must check is all is ok (no validation till now)
    # except a false in fileservice for nil object
    @edgefile = create_edges(params)
    @configfile = create_config(params)
    @annotationfile = create_annotation(params)
    
    true
    
  end

  private
  
  def create_annotation(params)
    if params['annotationfile'] && !params['annotationfile']['uploaded_data'].blank? then
      Annotationfile.new(params['annotationfile'])
    elsif params['annotations'] and !params['annotations'].blank? then
      set_annotationfile(params[:annotations])
    else
      # TODO
    end
  end
  
  def create_edges(params)
    if params['edgefile'] && !params['edgefile']['uploaded_data'].blank? then
      e = Edgefile.new(params['edgefile'])
    elsif params['edges'] && !params['edges'].blank? then
      e = set_edgefile(params['edges'])
    else
      e = Edgefile.new()
    end
    return e
  end
  
  def create_config(params)
    if params['configfile'] && !params['configfile']['uploaded_data'].blank? then
      Configfile.new(params['configfile'])
    elsif params['config'] && !params['config']['template'].blank? then
      set_template_config(params['config']['template'])
    else
      # Use form fields... TODO error messages on empty, etc...
      set_params_config(params['params'], params['colors'], params['flags'])
    end
  end
  
  def set_edgefile(edges)
    edgefile = Edgefile.new()
    edgefile.filename = 'pastie.txt'
    edgefile.content_type = 'text/plain'
    edgefile.set_temp_data(edges)
    edgefile
  end
  
  def save_edges
    if @edgefile.new_record? then
      @network.edgefile.destroy if @network.edgefile
      @edgefile.network = @network
      @edgefile.save!
    end
  end

  def save_config
    if @configfile.new_record? then
      @network.configfile.destroy if @network.configfile
      @configfile.network = @network
      @configfile.save!
    end
  end

  def save_annotation
    if @annotationfile.new_record? then
      @network.annotationfile.destroy if @network.annotationfile
      @annotationfile.network = @network
      @annotationfile.save!
    end
  end
  
  def get_config_templates
    templates = Hash.new
    templatesdir = Rails.root + "/" + CONFIG_TEMPLATES + "/*.xml"
    templatesfiles = Dir.glob(templatesdir)
    templatesfiles.each do |f|
      name = File.basename(f,'.xml')
      xml = REXML::Document.new(File.read(f))
      templates[name] = xml
    end
    return templates
  end

  def set_template_config(template)
    configfile = Configfile.new()
    configfile.filename = "#{template}.xml"
    configfile.content_type = 'text/xml'
    xml = @config_templates[ template ]
    configfile.set_temp_data(xml)
    configfile
  end

  def set_params_config(par, col, flags)
    configfile = Configfile.new()
    configfile.filename = "form.xml"
    configfile.content_type = 'text/xml'
    xml = REXML::Document.new('<config></config>')
    
    xmlpar = xml.root.add_element "params"
    par.each do |k,v|
      key = k.split("_")
      if xmlpar.elements[key[0]].nil? then
        xmlpar.add_element key[0]
      end
      e = xmlpar.elements[key[0]].add_element key[1]
      e.text = v
    end
    
    xmlcol = xml.root.add_element "colors"
    col.each do |k,v|
      key = k.split("_")
      if xmlcol.elements[key[0]].nil? then
        xmlcol.add_element key[0]
      end
      e = xmlcol.elements[key[0]].add_element key[1]
      e.text = v
    end
    
    xmlflag = xml.root.add_element "flags"
    flags.each do |k,v|
      e =xmlflag.add_element k
      e.text = v
    end
    configfile.filename = "form.xml"
    configfile.content_type = 'text/xml'
    configfile.set_temp_data(xml)
    configfile
  end

  def set_annotationfile(annotations)
    annotationfile = Annotationfile.new()
    annotationfile.filename = 'pastie.txt'
    annotationfile.content_type = 'text/plain'
    annotationfile.set_temp_data(annotations)
    annotationfile
  end
  
end
