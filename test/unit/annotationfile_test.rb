require 'test_helper'

class AnnotationfileTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    annotationfile = Annotationfile.new
    assert !annotationfile.valid?
    assert annotationfile.errors.invalid?(:filename)
  end

  test "invalid content type" do
    
    annotationfile = Annotationfile.new()
    annotationfile.filename = 'pippo.txt'
    annotationfile.size = 500

    annotationfile.content_type = 'application/pdf'
    assert !annotationfile.valid?
    assert_equal "error on content-type: #{annotationfile.content_type}", annotationfile.errors.on(:content_type)

    annotationfile.content_type = :image
    assert !annotationfile.valid?
    assert_equal "error on content-type: #{annotationfile.content_type}", annotationfile.errors.on(:content_type)
    
  end
 
  test "invalid size" do
    annotationfile = Annotationfile.new()
    annotationfile.filename = 'pippo.txt'
    annotationfile.content_type = 'text/plain'

    annotationfile.size = 5.megabyte
    assert !annotationfile.valid?
    assert_equal "error on size #{annotationfile.size}", annotationfile.errors.on(:size)
    
    annotationfile.size = 15.megabyte
    assert !annotationfile.valid?
    assert_equal "error on size #{annotationfile.size}", annotationfile.errors.on(:size)

  end
end
