require 'test_helper'

class NetworksControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:networks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get view page" do
    get :view, :id => networks(:barabasi).id
    assert_response :success
    assert_template "view"
  end
  
  test "should get network" do
    get :get_network, :id => networks(:barabasi).id
    assert_response :success
    assert_template "applet_small"
    assert_not_nil assigns(:network)
  end
  
  test "should raise error on get network with invalid id" do
    get :get_network, :id => 0
    assert_redirected_to networks_path
  end

  test "should create network" do
    network_hash = { 
      :name => 'pippo',
      :description => 'blablabla'
    }
    assert_difference('Network.count') do
      post :create, :network => network_hash,
        :edgefile => { :uploaded_data => fixture_file_upload("../storage/edgefiles/barabasi.txt", "text/plain") },
        :configfile => { :uploaded_data => fixture_file_upload("../storage/configfiles/barabasi.xml", "text/xml") },
        :annotationfile => { :uploaded_data => fixture_file_upload("../storage/annotationfiles/hprdmap.txt", "text/plain") }
    end

    newbie = Network.find(:all, :order => "id DESC", :limit =>  1)[0] 
    expected = Network.new(network_hash);
    assert_equal(newbie.name, expected.name)
    assert_equal(newbie.description, expected.description)
    assert_not_nil newbie.edgefile
    assert_not_nil newbie.configfile
    assert_not_nil newbie.annotationfile
    assert_equal("barabasi.txt", newbie.edgefile.filename)
    assert_equal("text/plain", newbie.edgefile.content_type)
    assert_equal("barabasi.xml", newbie.configfile.filename)
    assert_equal("text/xml", newbie.configfile.content_type)
    assert_equal("hprdmap.txt", newbie.annotationfile.filename)
    assert_equal("text/plain", newbie.annotationfile.content_type)

    assert_redirected_to network_path(assigns(:network))
  end

  test "should create network without annotation file" do
    network_hash = { 
      :name => 'pippo',
      :description => 'blablabla'
    }
    assert_difference('Network.count') do
      post :create, :network => network_hash,
        :edgefile => { :uploaded_data => fixture_file_upload("../storage/edgefiles/barabasi.txt", "text/plain") },
        :configfile => { :uploaded_data => fixture_file_upload("../storage/configfiles/barabasi.xml", "text/xml") }
    end
    newbie = Network.find(:all, :order => "id DESC", :limit =>  1)[0] 
    expected = Network.new(network_hash);
    assert_equal(newbie.name, expected.name)
    assert_equal(newbie.description, expected.description)
    assert_not_nil newbie.edgefile
    assert_not_nil newbie.configfile
    assert_equal("barabasi.txt", newbie.edgefile.filename)
    assert_equal("text/plain", newbie.edgefile.content_type)
    assert_equal("barabasi.xml", newbie.configfile.filename)
    assert_equal("text/xml", newbie.configfile.content_type)

    assert_redirected_to network_path(assigns(:network))
  end

  test "should create network from paste" do
    network_hash = { 
      :name => 'pippo',
      :description => 'blablabla'
    }

    edges = "A B\nA C\n"
    annotations = "A uno\nB due\nC tre\n"

    assert_difference('Network.count') do
      post :create, :network => network_hash,
        :edges => edges,
        :config => { :template => 'mrblue'},
        :annotations => annotations
    end
    newbie = Network.find(:all, :order => "id DESC", :limit =>  1)[0] 
    expected = Network.new(network_hash);
    assert_equal(newbie.name, expected.name)
    assert_equal(newbie.description, expected.description)
    assert_not_nil newbie.edgefile
    assert_not_nil newbie.configfile
    assert_not_nil newbie.annotationfile
    assert_equal("pastie.txt", newbie.edgefile.filename)
    assert_equal("text/plain", newbie.edgefile.content_type)
    assert_equal("mrblue.xml", newbie.configfile.filename)
    assert_equal("text/xml", newbie.configfile.content_type)
    assert_equal("pastie.txt", newbie.annotationfile.filename)
    assert_equal("text/plain", newbie.annotationfile.content_type)
    assert_redirected_to network_path(assigns(:network))
  end

  test "should show network" do
    network_id = networks(:disney).id
    get :show, :id => network_id
    assert_response :success
    assert_not_nil assigns(:network)
  end

  test "should get tags" do
    get :tag, :name => 'web'
    assert_response :success
  end
  
  test "should render new on network errors" do
    post :create
    assert_response :success
    assert_template "new"
  end

end
