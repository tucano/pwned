require 'test_helper'

class AnnotationserviceTest < Test::Unit::TestCase
  
  def setup
    @data = File.read('test/storage/annotationfiles/hprdmap.txt')
  end
  
  def test_validation
    @service = Annotationservice.new(@data)
    assert @service.valid?
  end
  
  def test_invalid_with_no_data
    data = nil
    @service = Annotationservice.new(data)
    assert !@service.valid?
  end
  
  def test_invalid_url
    data = "A pippo http:/\:,,,,::::ldsdsa%%$"
    @service = Annotationservice.new(data)
    assert !@service.valid?
  end
  
end
