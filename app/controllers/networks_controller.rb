class NetworksController < ApplicationController
  
  auto_complete_for :network, :name
  
  layout 'application', :except => [:get_network]
  
  # GET /networks
  # GET /networks.xml
  def index
    
    @networks = Network.search(params[:network])
    @pages = @networks.paginate :page => params[:page], :order => 'name', :per_page => 10
    
    respond_to do |format|
      format.html # index.html.erb
      format.rss { render :layout => false, :collection => @networks }
      format.xml  { render :xml => @networks }
    end
  end
  
  # GET /networks/search
  def search
    respond_to do |format|
      format.html # search.html.erb
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
  
  # TODO AJAX function to get a record (actually not used)
  # Example:
  # <div id="<%= network.name + 'box' %>" ></div>
  # <%= link_to_remote 'Show inline', 
  #     :url => { :action => 'get_network' , :id => network.id  }, 
  #     :update => { :success => "#{network.name}box", :failure => "notice" },
  #     :before => "Element.hide(\'#{network.name}box\')",
  #     :complete => "Element.show(\'#{network.name}box\')"
  #   %>
  def get_network
    begin
      @network = Network.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid network #{params[:id]}")
      render :text => "Invalid Network"
    else
      render :partial => 'applet_small'
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

  # GET /networks/1/edit
  def edit
    @network = Network.find(params[:id])
    @edgefile = @network.edgefile
    @configfile = @network.configfile
    @annotationfile = @network.annotationfile
    @service = Fileservice.new(@network, @edgefile, @configfile, @annotationfile)   
    @thisconfig = REXML::Document.new(File.read(@configfile.full_filename))
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

  # PUT /networks/1
  # PUT /networks/1.xml
  def update
    @network = Network.find(params[:id])
    @edgefile = @network.edgefile
    @configfile = @network.configfile
    @annotationfile = @network.annotationfile
    @service = Fileservice.new(@network, @edgefile, @configfile, @annotationfile)
    
    respond_to do |format|
      if @service.update_attributes(params)
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
  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    respond_to do |format|
      format.html { redirect_to(networks_url) }
      format.xml  { head :ok }
    end
  end

end
