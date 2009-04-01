class NetworksController < ApplicationController
  
  auto_complete_for :network, :name
  
  layout 'application', :except => [:get_network, :view]
  
  # GET /networks
  # GET /networks.xml
  def index
    
    @networks = Network.search(params[:network], { :order => "created_at DESC"})
    @pages = @networks.paginate :page => params[:page], :per_page => 50
    
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :layout => false, :collection => @networks }
      format.xml  { render :xml => @networks }
    end
  end
  
  # GET /networks/tag/name
  # GET /networks/tag/name.xml
  def tag
    @networks = Network.find_tagged_with(params[:name])
    @pages = @networks.paginate :page => params[:page], :order => 'name', :per_page => 5
    respond_to do |format|
      format.html { render :action => :index , :collection => @pages }
      format.rss { render :action => :index, :layout => false, :collection => @networks }
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
  
   # GET /networks/1/view
  def view
    @network = Network.find(params[:id])
    respond_to do |format|
      format.html { render :action => :view, :layout => 'fullscreen' }
    end
  end
  
  # AJAX action to get a record
  def get_network
    begin
      @network = Network.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid network #{params[:id]}")
      redirect_to_index("Invalid Network ID")
    else
      render :partial => 'applet', :locals => { 
        :height => 300, 
        :width => 400, 
        :codebase => '/applet/400x300', 
        :applet_class => "appletsmall" }
    end
  end

  # GET /networks/new
  # GET /networks/new.xml
  def new
    @network = Network.new
    @service = Fileservice.new(@network)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # POST /networks
  # POST /networks.xml
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
        format.html { redirect_to(@network) }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else       
        format.html { render :action => :new }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => :index
  end
end
