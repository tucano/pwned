require 'test_helper'

class EdgefileTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    edgefile = Edgefile.new
    assert !edgefile.valid?
    assert edgefile.errors.invalid?(:filename)
    assert edgefile.errors.invalid?(:size)
    assert edgefile.errors.invalid?(:content_type)
  end

  test "content type" do
    edgefile = Edgefile.new()
    edgefile.filename = 'pippo.txt'
    edgefile.size = 500

    edgefile.content_type = 'application/pdf'
    assert !edgefile.valid?
    assert_equal "edgefile error on content-type: #{edgefile.content_type}", edgefile.errors.on(:content_type)

    edgefile.content_type = :image
    assert !edgefile.valid?
    assert_equal "edgefile error on content-type: #{edgefile.content_type}", edgefile.errors.on(:content_type)
    
    edgefile.content_type = 'text/plain'
    assert edgefile.valid?, edgefile.errors.full_messages
  end

  test "size" do
    edgefile = Edgefile.new()
    edgefile.filename = 'pippo.txt'
    edgefile.content_type = 'text/plain'

    edgefile.size = 5.megabyte
    assert !edgefile.valid?
    assert_equal "edgefile error on size #{edgefile.size}", edgefile.errors.on(:size)
    
    edgefile.size = 15.megabyte
    assert !edgefile.valid?
    assert_equal "edgefile error on size #{edgefile.size}", edgefile.errors.on(:size)

    edgefile.size = 1.megabyte
    assert edgefile.valid?, edgefile.errors.full_messages
  end
end
