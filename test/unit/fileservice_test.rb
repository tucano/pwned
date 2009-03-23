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
    @edgefile.set_temp_data(File.read('test/storage/edgefiles/barabasi.txt'))
    @edgefile.content_type = 'text/plain'
    @configfile.filename = 'pippo.xml'
    @configfile.content_type = 'text/xml'
    @configfile.set_temp_data(File.read('test/storage/configfiles/barabasi.xml'))
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
    @edgefile.set_temp_data(File.read('test/storage/edgefiles/barabasi.txt'))
    @edgefile.content_type = 'text/plain'
    @configfile.filename = 'pippo.xml'
    @configfile.content_type = 'text/xml'
    @configfile.set_temp_data(File.read('test/storage/configfiles/barabasi.xml'))
    @annotationfile.filename = 'pippo.txt'
    @annotationfile.content_type = 'text/plain'
    @annotationfile.size = 500
    @service = Fileservice.new(@network,@edgefile,@configfile,@annotationfile) 
    assert @service.valid?
    assert @service.save
    assert @service.has_annotation?
    assert_equal @service.network.name, 'pippo'
    assert_equal @service.edgefile.filename, 'pippo.txt'
    assert_equal @service.configfile.filename, 'pippo.xml'
    assert_equal @service.annotationfile.filename, 'pippo.txt'
  end
  
  def test_should_not_create_entry_on_invalid_obects
    @network.name = 'pippo'
    @network.description = 'blablabla'
    @edgefile.filename = 'pippo.txt'
    @edgefile.size = 500
    @edgefile.content_type = 'text/plain'
    @configfile.filename = 'pippo.xml'
    @configfile.content_type = 'text/xml'
    bad = REXML::Document.new(File.read('test/storage/configfiles/barabasi.xml'))
    bad.root.elements[1].remove
    @service = Fileservice.new(@network,@edgefile,@configfile,@annotationfile)
    assert !@service.valid?
    assert !@service.save
  end
  
  def test_should_update_attributes
    @network.name = 'pippo'
    @network.description = 'blablabla'
    @edgefile.filename = 'pippo.txt'
    @edgefile.size = 500
    @edgefile.content_type = 'text/plain'
    @edgefile.set_temp_data(File.read('test/storage/edgefiles/barabasi.txt'))
    @configfile.filename = 'pippo.xml'
    @configfile.content_type = 'text/xml'
    @configfile.set_temp_data(File.read('test/storage/configfiles/barabasi.xml'))
    @service = Fileservice.new(@network,@edgefile,@configfile)
    assert @service.valid?
    assert @service.save
    assert !@service.has_annotation?
    params = { 'network' => {'name' => 'pluto', 'description' => 'pluplu'}, 
               'edges' => 'A B\n',
               'config' => { 'template' => 'classic' }
             }
    assert @service.update_attributes(params)
    assert @service.valid?
  end
  
  def test_should_create_files
    @network.name = 'pippo'
    @network.description = 'blablabla'
    @service = Fileservice.new(@network)
    params = { 'network' => {'name' => 'pluto', 'description' => 'pluplu'}, 
               'edges' => 'A B\n',
               'config' => { 'template' => 'classic' }
              }
    assert @service.create_files(params)
    assert @service.valid?
    assert @service.save
  end
end
