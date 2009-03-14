require 'test_helper'

class FileserviceTest < Test::Unit::TestCase
  def setup
    @network = Network.new()
    @edgefile = Edgefile.new()
    @configfile = Configfile.new()
    @annotationfile = Annotationfile.new()
  end

  def test_should_check_for_valid_objects
    @service = Fileservice.new(@network,@edgefile,@configfile,@annotationfile) 
    assert !@service.save
    assert !@service.valid?
    assert !@service.has_annotation?
  end

  def test_should_create_entry
    @network.name = 'pippo'
    @network.description = 'blablabla'
    @edgefile.filename = 'pippo.txt'
    @edgefile.size = 500
    @edgefile.content_type = 'text/plain'
    @configfile.filename = 'pippo.xml'
    @configfile.size = 500
    @configfile.content_type = 'text/xml'
    @service = Fileservice.new(@network,@edgefile,@configfile,@annotationfile) 
    assert @service.valid?
    assert @service.save
    assert !@service.has_annotation?
    assert_equal @service.network.name, 'pippo'
    assert_equal @service.edgefile.filename, 'pippo.txt'
    assert_equal @service.configfile.filename, 'pippo.xml'
  end

  def test_should_create_entry_with_annotation
    @network.name = 'pippo'
    @network.description = 'blablabla'
    @edgefile.filename = 'pippo.txt'
    @edgefile.size = 500
    @edgefile.content_type = 'text/plain'
    @configfile.filename = 'pippo.xml'
    @configfile.size = 500
    @configfile.content_type = 'text/xml'
    @annotationfile.filename = 'pippo.txt'
    @annotationfile.size = 500
    @annotationfile.content_type = 'text/plain'
    @service = Fileservice.new(@network,@edgefile,@configfile,@annotationfile) 
    assert @service.valid?
    assert @service.save
    assert @service.has_annotation?
    assert_equal @service.network.name, 'pippo'
    assert_equal @service.edgefile.filename, 'pippo.txt'
    assert_equal @service.configfile.filename, 'pippo.xml'
    assert_equal @service.annotationfile.filename, 'pippo.txt'
  end

end
