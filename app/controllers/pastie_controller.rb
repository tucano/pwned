class PastieController < ApplicationController
  layout 'networks'

  def new
    @network = Network.new
  end

  # POST /pastie
  def create
    @network = Network.new(params[:network])
    if @network.save
      flash[:notice] = 'Network was successfully created.'
      redirect_to(@network)
    else
      render :action => "new"
    end
  end

end
