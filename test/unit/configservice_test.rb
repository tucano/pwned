require 'test_helper'

class ConfigserviceTest < Test::Unit::TestCase
  
  def setup
    @xml = REXML::Document.new(File.read('test/storage/configfiles/barabasi.xml'))
  end
  
  def test_validation
    config = Configservice.new(@xml)
    assert config.valid?
  end
  
  def test_load
    config = Configservice.new(@xml)
    assert config.load
  end
  
  def test_not_valid_with_missing_nodes
    bad = REXML::Document.new(File.read('test/storage/configfiles/barabasi.xml'))
    bad.root.elements[1].remove
    config = Configservice.new(bad)
    assert !config.valid?
  end
  
  def test_not_valid_objects
    bads = ['string', nil, 1, Configfile.new]
    bads.each do |bad|
      config = Configservice.new(bad)
      assert !config.valid?
    end
  end
  
end
