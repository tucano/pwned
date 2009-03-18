require 'test_helper'

class ConfigserviceTest < Test::Unit::TestCase
  
  def setup
    @xml = REXML::Document.new(File.read('test/storage/configfiles/barabasi.xml'))
  end
  
  def test_valid_config
    config = Configservice.new(@xml)
    assert config.valid?
  end
  
  def test_load_config
    config = Configservice.new(@xml)
    assert config.load
  end
  
  def test_not_valid_config
    bad = REXML::Document.new(File.read('test/storage/configfiles/barabasi.xml'))
    bad.root.elements[1].remove
    config = Configservice.new(bad)
    assert !config.valid?
  end
    
end
