require 'test_helper'

class ConfigfileTest < ActiveSupport::TestCase

  test "invalid with empty filename" do
    configfile = Configfile.new
    assert !configfile.valid?
    assert configfile.errors.invalid?(:filename)
  end

  test "invalid content type" do
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.size = 500
    configfile.set_temp_data('<a>Test</a>')

    configfile.content_type = 'application/pdf'
    assert !configfile.valid?
    assert_equal "error on content-type: #{configfile.content_type}", configfile.errors.on(:content_type)

    configfile.content_type = :image
    assert !configfile.valid?
    assert_equal "error on content-type: #{configfile.content_type}", configfile.errors.on(:content_type)
  end
 
  test "invalid size" do
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.content_type = 'text/xml'

    configfile.size = 5.megabyte
    assert !configfile.valid?
    assert_equal "error on size #{configfile.size}", configfile.errors.on(:size)
    
    configfile.size = 15.megabyte
    assert !configfile.valid?
    assert_equal "error on size #{configfile.size}", configfile.errors.on(:size)
  end

end
