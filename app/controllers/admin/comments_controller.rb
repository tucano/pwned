class Admin::CommentsController < ApplicationController
  
  before_filter :load_network
  
  layout 'application'

  # GET /admin/network/:id/comments
  # GET /admin/network/:id/comments.xml
  def index
    
    @comments = @network.comments.find(:all, :order => 'created_at DESC')
    @comment_pages = @comments.paginate :page => params[:page], :per_page => 15
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  
  def show
    @comment = @network.comments.find(params[:id])
     
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end 
  end
  
  # GET /admin/comments/new
  # GET /admin/comments/new.xml
  def new
    @comment = @network.comments.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end
  
  # GET /comments/1/edit
  def edit
    @comment = @network.comments.find(params[:id])
  end
  
  # POST /admin/comments
  # POST /admin/comments.xml
  def create
    @comment = @network.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to([:admin, @network, :comments]) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/comments/1
  # PUT /admin/comments/1.xml
  def update
    @comment = @network.comments.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to([:admin, @network, :comments]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/comments/1
  # DELETE /admin/comments/1.xml
  def destroy
    @comment = @network.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      flash[:notice] = 'Comment destroyed.'
      format.html { redirect_to([:admin, @network,:comments]) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def load_network
    begin
      @network = Network.find(params[:network_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid comments for network #{params[:network_id]}")
      redirect_to_networks("Invalid Network")
    else
      return @network
    end
  end
  
end
