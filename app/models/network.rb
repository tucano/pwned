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

  # very basic AND DANGEROUS upload
  after_save :write_files
  after_destroy :remove_files

  def edgeupload=(file)
    self.edgefile = file.original_filename
    # check content/type
    logger.info file.content_type.chomp
    @edata = file.read
  end

  def annotationupload=(file)
    if file != "" then
      self.annotationfile = file.original_filename
      # check content/type
      logger.info file.content_type.chomp
      @ndata = file.read
    end
  end

  def configupload=(file)
    self.config = file.original_filename
    # check content/type (XML)
    logger.info file.content_type.chomp
    @cdata = file.read
  end

  def write_files
    basepath = RAILS_ROOT + '/public/storage/' + name
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

  def remove_files
    basepath = RAILS_ROOT + '/public/storage/' + name
    FileUtils.rm_rf(basepath)
  end
end
