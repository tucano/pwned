require 'test_helper'

class AnnotationfileTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    annotationfile = Annotationfile.new
    assert !annotationfile.valid?
    assert annotationfile.errors.invalid?(:filename)
    assert annotationfile.errors.invalid?(:size)
    assert annotationfile.errors.invalid?(:content_type)
  end

  test "content type" do
    
    annotationfile = Annotationfile.new()
    annotationfile.filename = 'pippo.txt'
    annotationfile.size = 500

    annotationfile.content_type = 'application/pdf'
    assert !annotationfile.valid?
    assert_equal "is not included in the list", annotationfile.errors.on(:content_type)

    annotationfile.content_type = :image
    assert !annotationfile.valid?
    assert_equal "is not included in the list", annotationfile.errors.on(:content_type)
    
    annotationfile.content_type = 'text/plain'
    assert annotationfile.valid?, annotationfile.errors.full_messages

  end
 
  test "size" do
    annotationfile = Annotationfile.new()
    annotationfile.filename = 'pippo.txt'
    annotationfile.content_type = 'text/plain'

    annotationfile.size = 5.megabyte
    assert !annotationfile.valid?
    assert_equal "is not included in the list", annotationfile.errors.on(:size)
    
    annotationfile.size = 15.megabyte
    assert !annotationfile.valid?
    assert_equal "is not included in the list", annotationfile.errors.on(:size)

    annotationfile.size = 1.megabyte
    assert annotationfile.valid?, annotationfile.errors.full_messages
  end
end
