require 'test_helper'

class NetworkTest < ActiveSupport::TestCase
  fixtures :networks

  def test_invalid_with_empty_attributes
    network = Network.new
    assert !network.valid?
    assert network.errors.invalid?(:name)
    assert network.errors.invalid?(:description)
    assert network.errors.invalid?(:edgefile)
    assert network.errors.invalid?(:config)
  end

  def test_edgefile_format
    ok = %w{ fred.txt pippo.txt pluto.txt }
    bad = %w{ pluto.doc pippo.xml }
    
    ok.each do |file|
      network = Network.new(
        :name => 'test',
        :description => 'blablabla',
        :edgefile => file,
        :annotationfile => 'notes.txt',
        :config => 'config.xml'
      )
      assert network.valid?, network.errors.full_messages
    end

    bad.each do |file|
      network = Network.new(
        :name => 'test',
        :description => 'blablabla',
        :edgefile => file,
        :annotationfile => 'notes.txt',
        :config => 'config.xml'
      )
      assert !network.valid?, "saving #{file}"
    end
  end

  def test_unique_name
    network = Network.new(
      :name => networks(:one).name,
      :description => 'blablabla',
      :edgefile => 'pippo.txt',
      :annotationfile => 'notes.txt',
      :config => 'config.xml'
    )
    assert !network.save
    assert_equal "has already been taken", network.errors.on(:name)
  end

end
