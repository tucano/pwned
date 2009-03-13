require 'test_helper'

class NetworkTest < ActiveSupport::TestCase

  #TODO TODO Remove edgefile, configfiles, etc... there is service now

  test "invalid with empty attributes" do
    network = Network.new
    assert !network.valid?
    assert network.errors.invalid?(:name)
    assert network.errors.invalid?(:description)
    # TODO there is fileservice now
    #assert network.errors.invalid?(:edgefile)
    #assert network.errors.invalid?(:configfile)
  end
  
  test "unique name" do
    network = Network.new(
      :name => networks(:barabasi).name,
      :description => 'blablabla',
      :edgefile => edgefiles(:barabasi),
      :configfile => configfiles(:barabasi)
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
        :description => 'blablabla',
        :edgefile => edgefiles(:barabasi),
        :configfile => configfiles(:barabasi)
      )
      assert !network.save
      assert_equal I18n.translate('activerecord.errors.messages')[:invalid], network.errors.on(:name)
    end

    good.each do |name|
      network = Network.new(
        :name => name,
        :description => 'blablabla',
        :edgefile => edgefiles(:barabasi),
        :configfile => configfiles(:barabasi)
      )
      assert network.valid?, network.errors.full_messages
      assert network.save
    end

  end

end
