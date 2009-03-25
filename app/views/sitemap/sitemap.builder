# see http://www.sitemaps.org/protocol.php and https://www.google.com/webmasters/tools/docs/en/protocol.html
xml.instruct!
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @pages.each do |page|
    xml.url do
      xml.loc network_url(page)
      xml.lastmod page.updated_at.xmlschema
    end
  end
end
