# FORMAT: ID LABEL URL
class Annotationservice
  
  def initialize(data)
    @data = data
  end
  
  def valid?
    return false if @data.nil?
    @data.each_line do |line|
      line.chomp
      notes = line.split
      return false unless (notes.size > 1 and notes.size < 4)
      # try to parse notes[2] as URI
      if notes[2] then
        begin 
          URI.parse(notes[2])
        rescue URI::InvalidURIError
          return false
        end
      end
    end
    return true
  end
  
end
