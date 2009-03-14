require 'test_helper'

class ConfigfileTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    configfile = Configfile.new
    assert !configfile.valid?
    assert configfile.errors.invalid?(:filename)
    assert configfile.errors.invalid?(:size)
    assert configfile.errors.invalid?(:content_type)
  end

  test "content type" do
    
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.size = 500

    configfile.content_type = 'application/pdf'
    assert !configfile.valid?
    assert_equal "configfile error on content-type: #{configfile.content_type}", configfile.errors.on(:content_type)

    configfile.content_type = :image
    assert !configfile.valid?
    assert_equal "configfile error on content-type: #{configfile.content_type}", configfile.errors.on(:content_type)
    
    configfile.content_type = 'text/xml'
    assert configfile.valid?, configfile.errors.full_messages

    configfile.content_type = 'application/xml'
    assert configfile.valid?, configfile.errors.full_messages

  end
 
  test "size" do
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.content_type = 'text/xml'

    configfile.size = 5.megabyte
    assert !configfile.valid?
    assert_equal "configfile error on size #{configfile.size}", configfile.errors.on(:size)
    
    configfile.size = 15.megabyte
    assert !configfile.valid?
    assert_equal "configfile error on size #{configfile.size}", configfile.errors.on(:size)

    configfile.size = 1.megabyte
    assert configfile.valid?, configfile.errors.full_messages
  end

end
