class Network < ActiveRecord::Base

  validates_presence_of :name, :description, :edgefile, :config
  
  validates_uniqueness_of :name

  validates_format_of :edgefile,
    :with => %r{\.txt}i,
    :message => "Must be a .txt file"
  validates_format_of :config,
    :with => %r{\.xml}i,
    :message => "Must be an xml file"
  validates_format_of :annotationfile,
    :with => %r{\.txt}i,
    :message => "Must be a .txt file",
    :if => :annotationfile

  # FIXME very basic AND DANGEROUS upload/pastie system
  after_save :write_files
  after_destroy :remove_files

  # FIXME why I need this and I not need it for annotationupload?
  attr_reader :edges, :nodes, :autoconfig
  def edges=(data)
    if (data != "") then
      self.edgefile = 'edges.txt'
      @edata = data
    end
  end

  def nodes=(data)
    if (data != "") then
      self.annotationfile = 'annotation.txt'
      @ndata = data
    end
  end

  def autoconfig=(type)
    templatepath = RAILS_ROOT + '/public/templates/' + type + '.xml'
    template = File.open(templatepath)
    self.config = type + '.xml'
    @cdata = template.read
  end

  def edgeupload=(file)
    self.edgefile = file.original_filename
    # TODO check content/type
    logger.info file.content_type.chomp
    @edata = file.read
  end

  def annotationupload=(file)
    if file != "" then
      self.annotationfile = file.original_filename
      # TODO check content/type
      logger.info file.content_type.chomp
      @ndata = file.read
    end
  end

  def configupload=(file)
    self.config = file.original_filename
    # TODO check content/type (XML)
    logger.info file.content_type.chomp
    @cdata = file.read
  end

  def write_files
    # FIXME horrible hack to avoid files overwrite in edit (save again)
    basepath = RAILS_ROOT + '/public/storage/' + name
    if File.exists?(basepath) then
      return
    else
      FileUtils.makedirs(basepath)
      efile = basepath + '/' + edgefile
      File.open(efile,"w") do |file| file.write(@edata) end
      cfile = basepath + '/' + config
      File.open(cfile,"w") do |file| file.write(@cdata) end

      if annotationfile then 
        nfile = basepath + '/' + annotationfile
        File.open(nfile,"w") do |file| file.write(@ndata) end
      end
    end
  end

  def remove_files
    basepath = RAILS_ROOT + '/public/storage/' + name
    FileUtils.rm_rf(basepath)
  end
end
