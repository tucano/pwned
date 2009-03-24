require 'test_helper'

class EdgefileTest < ActiveSupport::TestCase

  test "invalid with empty filename" do
    edgefile = Edgefile.new
    assert !edgefile.valid?
    assert edgefile.errors.invalid?(:filename)
  end

  test "content type" do
    edgefile = Edgefile.new()
    edgefile.filename = 'pippo.txt'
    edgefile.size = 500

    edgefile.content_type = 'application/pdf'
    assert !edgefile.valid?
    assert_equal "error on content-type: #{edgefile.content_type}", edgefile.errors.on(:content_type)

    edgefile.content_type = :image
    assert !edgefile.valid?
    assert_equal "error on content-type: #{edgefile.content_type}", edgefile.errors.on(:content_type)
    
  end

  test "size" do
    edgefile = Edgefile.new()
    edgefile.filename = 'pippo.txt'
    edgefile.content_type = 'text/plain'

    edgefile.size = 5.megabyte
    assert !edgefile.valid?
    assert_equal "error on size #{edgefile.size}", edgefile.errors.on(:size)
    
    edgefile.size = 15.megabyte
    assert !edgefile.valid?
    assert_equal "error on size #{edgefile.size}", edgefile.errors.on(:size)
  end
  
  test "save valid file" do
    file = File.read('test/storage/edgefiles/barabasi.txt')
    edgefile = Edgefile.new()
    edgefile.filename = 'pippo.txt'
    edgefile.content_type = 'text/plain'
    edgefile.set_temp_data(file)
    assert edgefile.valid?, edgefile.errors.full_messages
    assert edgefile.save, edgefile.errors.full_messages
  end

  test "error on empty file" do
    edgefile = Edgefile.new()
    edgefile.filename = 'pippo.txt'
    edgefile.content_type = 'text/plain'
    assert !edgefile.valid?
    assert !edgefile.save
    assert_equal "error on size #{edgefile.size}", edgefile.errors.on(:size)
  end
  
end
