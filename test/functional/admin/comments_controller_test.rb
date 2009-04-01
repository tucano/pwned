require 'test_helper'

class Admin::CommentsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index, :network_id => networks(:barabasi).id  
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should get new" do
    get :new, :network_id => networks(:barabasi).id 
    assert_response :success
    assert_template "new"
  end

  test "should get show" do
    get :show, :network_id => networks(:barabasi).id , :id => comments(:one).id
    assert_response :success
    assert_not_nil assigns(:comment)
    assert_template "show"
  end
  
  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, :comment => { :body => 'A comment here' }, :network_id => networks(:barabasi).id 
    end
    assert_redirected_to admin_network_comments_path
  end

  test "should get edit" do
    get :edit, :id => comments(:one).id, :network_id => networks(:barabasi).id
    assert_response :success
    assert_template "edit"
  end

  test "should update comment" do
    put :update, :id => comments(:one).id, :comment => { :body => "new comment" }, :network_id => networks(:barabasi).id
    assert_redirected_to admin_network_comments_path
  end

  test "should render new on errors" do
    post :create, :comment => { :body => "" }, :network_id => networks(:barabasi).id
    assert_response :success
    assert_template "new"
  end
  
  test "should render edit on errors" do
    put :update, :id => comments(:one).id, :comment => { :body => "" }, :network_id => networks(:barabasi).id
    assert_response :success
    assert_template "edit"
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:one), :network_id => networks(:barabasi).id
    end

    assert_redirected_to admin_network_comments_path
  end
  
end
