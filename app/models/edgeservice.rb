class Edgeservice
  
  def initialize(data)
    @data = data
  end
  
  def valid?
    return false if @data.nil?
    @data.each_line do |line|
      line.chomp
      nodes = line.split
      return false unless nodes.size == 2
    end
    return true
  end
  
end
