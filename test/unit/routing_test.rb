# ROUTING tests, test on :myurl parameter
require 'test_helper'

class RoutingTest < Test::Unit::TestCase
  
  def test_generates
    assert_generates "/networks", :controller => 'networks', :action => 'index'
    assert_generates "/networks/1", :controller => "networks", :action => "show", :id => 1

  end

  def test_recognizes
    assert_recognizes({:controller => 'networks', :action => 'create'}, {:path => 'networks', :method => :post})
  end

end
