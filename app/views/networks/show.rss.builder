xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title page_title
    xml.description "A pot of networks"
    xml.link formatted_networks_url
    
    xml.item do
      xml.title @network.name
      xml.description @network.description
      xml.pubDate @network.created_at.to_s(:rfc822)
      xml.link formatted_network_url(@network, :rss)
    end
  end
end