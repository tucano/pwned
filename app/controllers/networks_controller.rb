class NetworksController < ApplicationController
  
  # GET /networks
  # GET /networks.xml
  def index
    @networks = Network.find(:all)

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

  # GET /networks/1/edit
  def edit
    @network = Network.find(params[:id])
  end

  # POST /networks
  # POST /networks.xml
  def create
    @network = Network.new(params[:network])
    @network.edgefile = Edgefile.new(params[:edgefile])
    @network.configfile = Configfile.new(params[:configfile])
    # TODO AnnotationService Adv rails recipes
    # FIXME this is an hack
    if params[:annotationfile][:uploaded_data] != "" then
      @network.annotationfile = Annotationfile.new(params[:annotationfile])
    end

    respond_to do |format|
      if @network.save
        flash[:notice] = 'Network was successfully created.'
        format.html { redirect_to(@network) }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /networks/1
  # PUT /networks/1.xml
  def update
    @network = Network.find(params[:id])

    # FIXME this is an hack
    if params[:edgefile][:uploaded_data] != "" then
      @network.edgefile = Edgefile.new(params[:edgefile])
    end
    # FIXME this is an hack
    if params[:configfile][:uploaded_data] != "" then
      @network.configfile = Configfile.new(params[:configfile])
    end
    # FIXME this is an hack
    if params[:annotationfile][:uploaded_data] != "" then
      @network.annotationfile = Annotationfile.new(params[:annotationfile])
    end

    respond_to do |format|
      if @network.update_attributes(params[:network])
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

end
