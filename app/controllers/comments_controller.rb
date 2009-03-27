class CommentsController < ApplicationController

  before_filter :load_network

  layout 'application', :except => [:get_comments]

  # GET /comments
  # GET /comments.xml
  # GET /network/:id/comments
  # GET /network/:id/comments.xml
  def index
    
    @comments = @network.comments.find(:all)
    @comment_pages = @comments.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 5
    
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

  # GET /comments/new
  # GET /comments/new.xml
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

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @network.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to([@network, :comments]) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = @network.comments.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to([@network, :comments]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @network.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to([@network,:comments]) }
      format.xml  { head :ok }
    end
  end
  
  # AJAX action to get comments
  def get_comments
    @comments = @network.comments.find(:all, :order => 'created_at DESC', :limit => 5)
    @comment = Comment.new()
    render :partial => 'inline_comments'
  end
  
  # AJAX action to create comment
  # FIXME please
  def add_comment 
    @comment = @network.comments.build(params[:comment])
    if @comment.save then
      @comments = @network.comments.find(:all, :order => 'created_at DESC', :limit => 5)
      logger.info("Created valid comment for network #{params[:network_id]}")
    else
      @comments = @network.comments.find(:all, :order => 'created_at DESC', :limit => 5)
      logger.error("Attempt to create invalid comment for network #{params[:network_id]}")
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
  
  def redirect_to_networks(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => :index, :controller => :networks
  end
  
end
