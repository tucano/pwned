class Configservice

  attr_reader :xml, :params, :colors, :flags
  attr_reader :node_opts, :edge_opts, :global_opts

  def initialize(xml = nil)
    @xml = xml
  end
  
  def valid?

    # lazy xml validation... no DTD
    return false unless @xml.class == REXML::Document
    return false unless @xml.has_elements?
    return false unless @xml.root.name == 'config'
    return false unless @xml.root.has_elements?
    return false unless check_params(@xml.root.elements[1])
    return false unless check_colors(@xml.root.elements[2])
    return false unless check_flags(@xml.root.elements[3])
    true
  end
  
  def load
    return false unless valid?
    @params = @xml.root.elements[1]
    @colors = @xml.root.elements[2]
    @flags  = @xml.root.elements[3]
    return false unless set_node_opts
    return false unless set_edge_opts
    return false unless set_global_opts
    true
  end
  
  private

  def set_global_opts
    # TODO more validations here
    @global_opts = Hash.new
    @global_opts["label"] = set_label_opts
    @global_opts["background"] = set_background_opts
    @global_opts["withlinks"] = @flags.elements["withlinks"].text
    @global_opts["directed"] = @flags.elements["directed"].text
    @global_opts["font"] = set_font_opts
    @global_opts["stroke"] = set_stoke_opts
    @global_opts["spacer"] = set_spacer_opts
    return true
  end
  
  def set_spacer_opts
    spacer_opts = Hash.new
    @params.elements["spacer"].each_element do |e|
      spacer_opts[e.name] = e.text
    end
    return spacer_opts
  end
  
  def set_stoke_opts
    stroke_opts = Hash.new
    @params.elements["stroke"].each_element do |e|
      stroke_opts[e.name] = e.text
    end
    return stroke_opts
  end
  
  def set_node_opts
    # TODO more validations here
    return false if @params.elements["node"].nil?
    @node_opts = Hash.new  
    @params.elements["node"].each_element do |e|
      @node_opts[e.name] = e.text
    end
    @colors.each_element do |e|
      if e.name.include? "node" then
        color = Hash.new
        e.each_element { |c|  color[c.name] = c.text }
        @node_opts[e.name] = color
      end
    end
    @flags.each_element do |e|
      if e.name.include? "node" then
        @node_opts[e.name] = e.text
      end
    end
    true
  end
  
  def set_edge_opts
    # TODO more validations here
    return false if @params.elements["edge"].nil?
    
    @edge_opts = Hash.new
    @params.elements["edge"].each_element do |e|
      @edge_opts[e.name] = e.text
    end
    @colors.each_element do |e|
      if e.name.include? "edge" then
        color = Hash.new
        e.each_element { |c|  color[c.name] = c.text }
        @edge_opts[e.name] = color
      end
    end
    @flags.each_element do |e|
      if e.name.include? "edge" then
        @edge_opts[e.name] = e.text
      end
    end
    true
  end
 
  def set_font_opts
    font_opts = Hash.new
    @params.elements["font"].each_element do |e|
      font_opts[e.name] = e.text
    end
    return font_opts
  end
  
  def set_background_opts
    background_opts = Hash.new
    @colors.each_element do |e|
     if e.name.include? "background" then
       e.each_element { |c|  background_opts[c.name] = c.text }
     end
    end
    return background_opts
  end
  
  def set_label_opts
    label_opts = Hash.new
    @colors.each_element do |e|
      if e.name.include? "label" then
        e.each_element { |c|  label_opts[c.name] = c.text }
      end
    end
    @flags.each_element do |e|
      if e.name.include? "label" then
        label_opts[e.name] = e.text
      end
    end
    return label_opts
  end
  
  def check_params(data)  
    return false if data.nil?
    return false unless data.name == 'params'
    allowed = ["node","spacer","edge","stroke","font"]
    data.each_element do |e|
      return false unless allowed.include? e.name
    end
    true
  end  

  def check_colors(data)
    return false if data.nil?
    return false unless data.name == 'colors'
    allowed = ["background","node1","node2","edge","label"]
    data.each_element do |e|
      return false unless allowed.include? e.name
    end
    true
  end  

  def check_flags(data)
    return false if data.nil?
    return false unless data.name == 'flags'    
    allowed = ["drawedges","drawnodes","drawlabels","withlinks","directed"]
    data.each_element do |e|
      return false unless allowed.include? e.name
    end
    true
  end  
  
end
