require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  test "should create comment" do
    back = network_path(:id => networks(:barabasi).id)
    @request.env["HTTP_REFERER"] = back
    assert_difference('Comment.count') do
      post :create, :comment => { :body => 'A comment here' }, :network_id => networks(:barabasi).id 
    end
    assert_redirected_to back
  end
  
end
