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
    configfile.filename = 'pippo.txt'
    configfile.size = 500

    configfile.content_type = 'application/pdf'
    assert !configfile.valid?
    assert_equal "is not included in the list", configfile.errors.on(:content_type)

    configfile.content_type = :image
    assert !configfile.valid?
    assert_equal "is not included in the list", configfile.errors.on(:content_type)
    
    configfile.content_type = 'text/xml'
    assert configfile.valid?, configfile.errors.full_messages

  end
 

end
