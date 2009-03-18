require 'test_helper'

class EdgeserviceTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def setup
    @data = File.read('test/storage/edgefiles/barabasi.txt')
  end
  
  def test_validation
    @service = Edgeservice.new(@data)
    assert @service.valid?
  end
  
  def test_not_valid
    data = "a b c c\na"
    @service = Edgeservice.new(data)
    assert !@service.valid?
  end
  
end
