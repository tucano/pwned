class Admin::NetworksController < ApplicationController
  
  layout 'application', :except => [:view]
  
  # GET /admin/networks
  # GET /admin/networks.xml
  def index

    @networks = Network.search(params[:network], { :order => "created_at DESC"})
    @pages = @networks.paginate :page => params[:page], :per_page => 5
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @networks }
    end
  end
  
  # GET /admin/networks/search
  def search
    respond_to do |format|
      format.html # search.html.erb
    end
  end

  # GET /admin/networks/tag/name
  # GET /admin/networks/tag/name.xml
  def tag
    @networks = Network.find_tagged_with(params[:name])
    @pages = @networks.paginate :page => params[:page], :order => 'name', :per_page => 5
    respond_to do |format|
      format.html { render :action => :index , :collection => @pages }
      format.xml  { render :xml => @networks }
    end
  end

  # GET /admin/networks/1
  # GET /admin/networks/1.xml
  def show
    @network = Network.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @network }      
    end
  end
  
  # GET /admin/networks/new
  # GET /admin/networks/new.xml
  def new
    @network = Network.new
    @service = Fileservice.new(@network)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # GET /admin/networks/1/edit
  def edit
    @network = Network.find(params[:id])
    @edgefile = @network.edgefile
    @configfile = @network.configfile
    @annotationfile = @network.annotationfile
    @service = Fileservice.new(@network, @edgefile, @configfile, @annotationfile)   
    @thisconfig = REXML::Document.new(File.read(@configfile.full_filename))
  end

  # POST /admin/networks
  # POST /admin/networks.xml
  def create
    @network = Network.new(params[:network])
    @service = Fileservice.new(@network)
    @service.create_files(params)
    @edgefile = @service.edgefile
    @configfile = @service.configfile
    @annotationfile = @service.annotationfile
    respond_to do |format|
      if @service.save
        flash[:notice] = 'Network was successfully created.'
        format.html { redirect_to([:admin, @network]) }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else       
        format.html { render :action => :new }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/networks/1
  # PUT /admin/networks/1.xml
  def update
    @network = Network.find(params[:id])
    @edgefile = @network.edgefile
    @configfile = @network.configfile
    @annotationfile = @network.annotationfile
    @service = Fileservice.new(@network, @edgefile, @configfile, @annotationfile)
    
    respond_to do |format|
      if @service.update_attributes(params)
        flash[:notice] = 'Network was successfully updated.'
        format.html { redirect_to([:admin, @network]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/networks/1
  # DELETE /admin/networks/1.xml
  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    respond_to do |format|
      format.html { redirect_to(admin_networks_url) }
      format.xml  { head :ok }
    end
  end

end
