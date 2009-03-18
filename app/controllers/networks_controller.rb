class NetworksController < ApplicationController
  
  # GET /networks
  # GET /networks.xml
  def index
    @networks = Network.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @networks }
    end
  end

  # GET /networks/1
  # GET /networks/1.xml
  def show

    @network = Network.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # GET /networks/new
  # GET /networks/new.xml
  def new
    @network = Network.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # GET /networks/paste
  # GET /networks/paste.xml
  def paste
    @network = Network.new
    @configs = get_config_templates
    @templates = @configs.keys
    flash[:paste] = true

    respond_to do |format|
      format.html # paste.html.erb
      # FIXME this xml
      format.xml  { render :xml => @network }
    end
  end

  # GET /networks/1/edit
  def edit
    @network = Network.find(params[:id])
  end

  # POST /networks
  # POST /networks.xml
  def create
    # check what we have: files or data?
    @network = Network.new(params[:network])
    
    if params[:edgefile] then
      @edgefile = Edgefile.new(params[:edgefile])
    elsif params[:edges] then
      @edgefile = Edgefile.new()
      # TODO FIXME
      @edgefile.filename = 'pastie.txt'
      @edgefile.content_type = 'text/plain'
      @edgefile.set_temp_data(params[:edges])
    end

    if params[:configfile] then
      @configfile = Configfile.new(params[:configfile])
    elsif params[:config] then
      @configfile = Configfile.new()
      # TODO FIXME
      @configs = get_config_templates
      @templates = @configs.keys
      @configfile.filename = 'pastie.xml'
      @configfile.content_type = 'text/xml'
      xml = @configs[ params[:config] ].xml
      @configfile.set_temp_data(xml)
    end

    if params[:annotationfile] then
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
        if flash[:paste] then
          format.html { render :action => :paste }
          flash[:paste] = true
        else
          format.html { render :action => :new }
        end
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
      xml = REXML::Document.new(File.read f)
      config = Configservice.new(xml)
      templates[name] = config if config.valid?
    end
    return templates
  end
end
