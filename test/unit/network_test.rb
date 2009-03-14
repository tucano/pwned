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
    assert !network.save, "Saved without unique name"
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], network.errors.on(:name)
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
      assert_equal I18n.translate('activerecord.errors.messages')[:invalid], network.errors.on(:name)
    end

    good.each do |name|
      network = Network.new(
        :name => name,
        :description => 'blablabla'
      )
      assert network.valid?, network.errors.full_messages
      assert network.save
    end

  end

end
