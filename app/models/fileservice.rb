class Fileservice

  attr_reader :network, :edgefile, :configfile, :annotationfile

  def initialize(network, edgefile, configfile, annotationfile)
    @network = network
    @edgefile = edgefile
    @configfile = configfile
    @annotationfile = annotationfile
  end

  def save
    return false unless valid?
    begin 
      Network.transaction do
        if @edgefile.new_record?
          @network.edgefile.destroy if @network.edgefile
          @edgefile.network = @network
          @edgefile.save!
        end
        if @configfile.new_record?
          @network.configfile.destroy if @network.configfile
          @configfile.network = @network
          @configfile.save!
        end
        if @annotationfile.new_record?
          @network.annotationfile.destroy if @network.annotationfile
          @annotationfile.network = @network
          @annotationfile.save!
        end
        @network.save!
      end
    rescue
      false
    end
  end

  def valid?
    # remove valid? for files (size is stored only on load in storage...)
    @network.valid?
  end
end
