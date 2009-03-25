class SitemapController < ApplicationController
  
  def sitemap
    @pages = Network.find_for_sitemap
    headers["Last-Modified" ] = @pages[0].updated_at.httpdate if @pages[0]
    render :layout => false
  end
  
end
