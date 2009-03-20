class NetworksController < ApplicationController
  
  auto_complete_for :network, :name
  layout "networks", :except => [:get_network]
  
  # GET /networks
  # GET /networks.xml
  def index
    
    @networks = Network.search(params[:network])
    @pages = @networks.paginate :page => params[:page], :order => 'name', :per_page => 5
    
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :layout => false, :collection => @networks }
      format.xml  { render :xml => @networks }
    end
  end

  # GET /networks/1
  # GET /networks/1.xml
  def show
    @network = Network.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.rss { render :layout => false }
      format.xml  { render :xml => @network }
    end
  end
  
  def get_network
    begin
      @network = Network.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid network #{params[:id]}")
      render :text => "Invalid Network"
    else
      render :partial => @network
    end
  end

  # GET /networks/new
  # GET /networks/new.xml
  def new
    @network = Network.new
    @configs = get_config_templates
    @templates = @configs.keys
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # GET /networks/1/edit
  def edit
    @network = Network.find(params[:id])
    @configs = get_config_templates
    @templates = @configs.keys
  end

  # POST /networks
  # POST /networks.xml
  def create
    @network = Network.new(params[:network])
    # TODO FIXME
    @configs = get_config_templates
    @templates = @configs.keys
    
    if params[:edgefile] && !params[:edgefile][:uploaded_data].blank? then
      @edgefile = Edgefile.new(params[:edgefile])
    elsif params[:edges] then
      @edgefile = Edgefile.new()
      # TODO FIXME
      @edgefile.filename = 'pastie.txt'
      @edgefile.content_type = 'text/plain'
      @edgefile.set_temp_data(params[:edges])
    end

    if params[:configfile] && !params[:configfile][:uploaded_data].blank? then
      @configfile = Configfile.new(params[:configfile])
    elsif params[:config] then
      @configfile = Configfile.new()
      @configfile.filename = 'pastie.xml'
      @configfile.content_type = 'text/xml'
      xml = @configs[ params[:config] ].xml
      @configfile.set_temp_data(xml)
    end

    if params[:annotationfile] && !params[:annotationfile][:uploaded_data].blank? then
      @annotationfile = Annotationfile.new(params[:annotationfile])
    elsif params[:annotations] and !params[:annotations].blank? then
      @annotationfile = Annotationfile.new()
      # TODO FIXME      
      @annotationfile.filename = 'pastie.txt'
      @annotationfile.content_type = 'text/plain'
      @annotationfile.set_temp_data(params[:annotations])
    end

    @service = Fileservice.new(@network, @edgefile, @configfile,@annotationfile)

    respond_to do |format|
      if @service.save
        flash[:notice] = 'Network was successfully created.'
        format.html { redirect_to(@network) }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else       
        format.html { render :action => :new }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /networks/1
  # PUT /networks/1.xml
  def update
    @network = Network.find(params[:id])
    @edgefile = @network.edgefile
    @configfile = @network.configfile
    @annotationfile = @network.annotationfile
    @service = Fileservice.new(@network, @edgefile, @configfile, @annotationfile)

    respond_to do |format|
      if @service.update_attributes(params[:network],params[:edgefile],params[:configfile],params[:annotationfile])
        flash[:notice] = 'Network was successfully updated.'
        format.html { redirect_to(@network) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.xml
  # TODO what we do with this Destroy method? AdminAccess
  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    respond_to do |format|
      format.html { redirect_to(networks_url) }
      format.xml  { head :ok }
    end
  end

  private
  
  def get_config_templates
    templates = Hash.new
    templatesdir = Rails.root + "/" + CONFIG_TEMPLATES + "/*.xml"
    templatesfiles = Dir.glob(templatesdir)
    templatesfiles.each do |f|
      name = File.basename(f,'.xml')
      xml = REXML::Document.new(File.read(f))
      config = Configservice.new(xml)
      templates[name] = config if config.valid?
    end
    return templates
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => :index
  end
end
