require 'test_helper'

class ConfigfileTest < ActiveSupport::TestCase

  test "invalid with empty filename" do
    configfile = Configfile.new
    assert !configfile.valid?
    assert configfile.errors.invalid?(:filename)
    assert_equal "can't be blank", configfile.errors[:filename]
  end

  test "invalid content type" do
    data = File.read('test/storage/configfiles/barabasi.xml')
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.size = 500
    configfile.set_temp_data(data)

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
  
  test "valid entry" do
    data = File.read('test/storage/configfiles/barabasi.xml')
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.content_type = 'text/xml'
    configfile.set_temp_data(data)
    
    assert configfile.valid?, configfile.errors.full_messages
    assert configfile.save, configfile.errors.full_messages
  end
  
  test "error on empty file" do
    configfile = Configfile.new()
    configfile.filename = 'pippo.xml'
    configfile.content_type = 'text/xml'
    assert !configfile.valid?
    assert !configfile.save
    assert_equal "error on size #{configfile.size}", configfile.errors.on(:size)
  end

end
