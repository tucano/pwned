require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
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

  test "should create comment" do
    assert_difference('Comment.count') do
      post :create, :comment => { :body => 'A comment here' }, :network_id => networks(:barabasi).id 
    end
    assert_redirected_to network_comments_path(assigns(:network))
  end

  test "should get edit" do
    get :edit, :id => comments(:one).id
    assert_response :success
  end

  test "should update comment" do
    put :update, :id => comments(:one).id, :comment => { :body => "new comment" }
    assert_redirected_to network_comments_path(comments(:one).network)
  end
  
  test "should render new on errors" do
    post :create, :comment => { :body => "" }, :network_id => networks(:barabasi).id
    assert_response :success
    assert_template "new"
  end
  
  test "should render edit on errors" do
    put :update, :id => comments(:one).id, :comment => { :body => "" }
    assert_response :success
    assert_template "edit"
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => comments(:one)
    end

    assert_redirected_to network_comments_path(comments(:one).network)
  end
end
