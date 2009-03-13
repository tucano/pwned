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

  test "should create network" do
    network_hash = { 
      :name => 'pippo',
      :description => 'blablabla'
    }
    assert_difference('Network.count') do
      post :create, :network => network_hash,
        :edgefile => { :uploaded_data => fixture_file_upload("../storage/edgefiles/barabasi.txt", "text/plain") },
        :configfile => { :uploaded_data => fixture_file_upload("../storage/configfiles/barabasi.xml", "text/xml") },
    # FIXME this is an hack
        :annotationfile =>{ :uploaded_data => ""}
    end

    newbie = Network.find(:all, :order => "id DESC", :limit =>  1)[0] 
    assert_not_nil newbie.edgefile
    assert_not_nil newbie.configfile
    assert_equal("barabasi.txt", newbie.edgefile.filename)
    assert_equal("barabasi.xml", newbie.configfile.filename)

    assert_redirected_to network_path(assigns(:network))
  end

  test "should show network" do
    get :show, :id => networks(:disney).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => networks(:disney).id
    assert_response :success
  end

  test "should update network" do
    network_hash = { 
      :name => 'pippo',
      :description => 'blablabla'
    }
    # FIXME this is an hack
    put :update, :id => networks(:disney).id, :network => network_hash, :annotationfile =>{ :uploaded_data => ""}, :edgefile =>{ :uploaded_data => ""}, :configfile =>{ :uploaded_data => ""}
    assert_redirected_to network_path(assigns(:network))
  end

  test "should destroy network" do
    assert_difference('Network.count', -1) do
      delete :destroy, :id => networks(:disney).id
    end

    assert_redirected_to networks_path
  end
end
