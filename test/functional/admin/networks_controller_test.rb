require 'test_helper'

class Admin::NetworksControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:networks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get search page" do
    get :search, :network => { :name => 'Barabsi'}
    assert_response :success
    assert_template "search"
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

    assert_redirected_to admin_network_path(assigns(:network))
  end
  
  test "should get edit" do
    network_id = networks(:barabasi).id
    get :edit, :id => network_id
    assert_response :success
  end
  
  test "should update network attributes" do
    network_id = networks(:disney).id
    old = Network.find(network_id) 
    network_hash = { 
      :name => 'pippo',
      :description => 'blablabla'
    }
    put :update, :id => network_id, :network => network_hash, :config => { :template => 'classic'}
    
    updated = Network.find(network_id) 
    assert_equal 'pippo', updated.name
    assert_equal 'blablabla', updated.description
    assert_not_nil updated.edgefile
    assert_not_nil updated.configfile
    assert_equal old.edgefile, updated.edgefile
    assert_equal old.configfile, updated.configfile
    assert_redirected_to admin_network_path(assigns(:network))
  end

  test "should update network files" do
    network_id = networks(:disney).id
    old = Network.find(network_id) 
    put :update, :id => network_id, 
      :edgefile => { :uploaded_data => fixture_file_upload("../storage/edgefiles/barabasi.txt", "text/plain") }, 
      :configfile => { :uploaded_data => fixture_file_upload("../storage/configfiles/barabasi.xml", "text/xml") },
      :annotationfile => { :uploaded_data => fixture_file_upload("../storage/annotationfiles/hprdmap.txt", "text/plain") }

    updated = Network.find(network_id) 
    assert_equal old.name, updated.name
    assert_equal old.description, updated.description
    assert_not_nil updated.edgefile
    assert_not_nil updated.configfile
    assert_not_nil updated.annotationfile
    assert_equal("barabasi.txt", updated.edgefile.filename)
    assert_equal("text/plain", updated.edgefile.content_type)
    assert_equal("barabasi.xml", updated.configfile.filename)
    assert_equal("text/xml", updated.configfile.content_type)
    assert_equal("hprdmap.txt", updated.annotationfile.filename)
    assert_equal("text/plain", updated.annotationfile.content_type)

    assert_redirected_to admin_network_path(assigns(:network))
  end
  
  test "should destroy network" do
    assert_difference('Network.count', -1) do
      delete :destroy, :id => networks(:disney).id
    end
    
    assert_redirected_to admin_networks_path
  end

  test "should render edit on network errors" do
    network_id = networks(:disney).id
    old = Network.find(network_id) 
    network_hash = { 
      :name => 'pippo',
      :description => ''
    }
    put :update, :id => network_id, :network => network_hash, :config => { :template => 'classic'}
    updated = Network.find(network_id) 
    assert_equal old, updated
    assert_response :success
    assert_template "edit"
  end

  
end
