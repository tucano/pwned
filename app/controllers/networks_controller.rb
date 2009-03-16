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

  # GET /networks/paste
  # GET /networks/paste.xml
  # TODO handle past form here
  def paste
    @network = Network.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # POST /networks/paste
  # POST /networks/paste.xml
  # TODO handle paste here
  def paste_create
    # Now strategy is:
    # get data
    # load data in empty model with set_temp_data
    # add filename a content_type

    @network = Network.new(params[:network])

    @edgefile = Edgefile.new()
    @edgefile.filename = 'pastie.txt'
    @edgefile.content_type = 'text/plain'
    @edgefile.set_temp_data(params[:edges])

    @configfile = Configfile.new()
    @configfile.filename = 'pastie.xml'
    @configfile.content_type = 'text/xml'
    @configfile.set_temp_data(params[:configs])

    @annotationfile = Annotationfile.new()
    @annotationfile.filename = 'pastie.txt'
    @annotationfile.content_type = 'text/plain'
    @annotationfile.set_temp_data(params[:annotations])

    @service = Fileservice.new(@network, @edgefile, @configfile,@annotationfile)
    respond_to do |format|
      if @service.save
        flash[:notice] = 'Network was successfully created.'
        format.html { redirect_to(@network) }
        format.xml  { render :xml => @network, :status => :created, :location => @network }
      else
        format.html { render :action => "paste" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
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
    @edgefile = Edgefile.new(params[:edgefile])
    @configfile = Configfile.new(params[:configfile])
    @annotationfile = Annotationfile.new(params[:annotationfile])
    @service = Fileservice.new(@network, @edgefile, @configfile,@annotationfile)

    respond_to do |format|
      if @service.save
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

end
