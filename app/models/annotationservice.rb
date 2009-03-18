class Annotationservice
  
  def initialize(data)
    @data = data
  end
  
  def valid?
    return false if @data.nil?
    true
  end
  
end
