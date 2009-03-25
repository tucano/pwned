class CommentsController < ApplicationController

  # TODO FIXME this controller and redirections (is a partial), then no more redirections to @comments
  before_filter :load_network

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
  
  private
  def load_network
    @network = Network.find(params[:network_id])
  end
  
end
