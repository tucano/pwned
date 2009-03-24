require 'test_helper'

class NetworkTest < ActiveSupport::TestCase

  test "invalid with empty attributes" do
    network = Network.new
    assert !network.valid?, "Validated invalid record"
    assert network.errors.invalid?(:name)
    assert network.errors.invalid?(:description)
    assert_equal I18n.translate('activerecord.errors.messages')[:blank], network.errors.on(:name)
    assert_equal I18n.translate('activerecord.errors.messages')[:blank], network.errors.on(:name)
  end
  
  test "unique name" do
    network = Network.new(
      :name => networks(:barabasi).name,
      :description => 'blablabla'
    )
    assert !network.valid?, "Validated invalid record"
    assert !network.save, "Saved without unique name"
    assert_equal I18n.translate('activerecord.errors.messages')[:taken], network.errors.on(:name)
  end

  test "name format" do
    bad = ["jhy hynjr", "\\inkjf1?!", "?", "!?", ";", "'", "1test", "12345678test", "-test", "test-1"]
    good = ["test", "test4", "lupo67", "Precipitando", "Ah_beh_ci_siamo", "test12345678", "test_1"]
    
    bad.each do |name|
      network = Network.new(
        :name => name,
        :description => 'blablabla'
      )
      assert !network.save, "Saved with bad name #{name}"
      assert_equal I18n.translate('activerecord.errors.messages')[:invalid], network.errors.on(:name)
    end

    good.each do |name|
      network = Network.new(
        :name => name,
        :description => 'blablabla'
      )
      assert network.valid?, "#{name} not valid: #{network.errors.full_messages}"
      assert network.save, network.errors.full_messages
    end
  end
  
  test "create new and find it by name" do
    network = Network.new(
      :name => 'Findme',
      :description => 'blablabla'
    )
    assert network.valid?, network.errors.full_messages
    assert network.save
    params = { 'name' => 'Findme' }
    search = Network.search(params)
    assert_equal 1, search.size
    assert_equal network, search[0]    
  end
  
  test "get all netowrks" do
    expected = Network.find(:all)
    actual = Network.search()
    assert_equal expected, actual
  end
  
  test "search single networks by name" do
    networks = Network.find(:all)
    networks.each do |expected|
      actual = Network.search('name' => expected.name)
      assert_equal 1, actual.size
      assert_equal expected, actual[0]
    end
  end
  
  # TODO act_as_taggable testing? (don't have model)
  
end
