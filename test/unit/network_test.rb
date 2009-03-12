require 'test_helper'

class NetworkTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    network = Network.new
    assert !network.valid?
    assert network.errors.invalid?(:name)
    assert network.errors.invalid?(:description)
  end
  
  test "unique name" do
    network = Network.new(
      :name => networks(:barabasi).name,
      :description => 'blablabla'
    )
    assert !network.save
    assert_equal "has already been taken", network.errors.on(:name)
  end

  test "name format" do
    bad = ["jhy hynjr", "\\inkjf1?!", "?", "!?", ";", "'"]
    good = ["test", "test4", "lupo67", "Precipitando", "Ah_beh_ci_siamo"]
    
    bad.each do |name|
      network = Network.new(
        :name => name,
        :description => 'blablabla'
      )
      assert !network.save
      assert_equal "is invalid", network.errors.on(:name)
    end

    good.each do |name|
      network = Network.new(
        :name => name,
        :description => 'blablabla'
      )
      assert network.valid?, network.errors.full_messages
    end

  end

end
