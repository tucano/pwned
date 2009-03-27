require 'test_helper'

class SitemapControllerTest < ActionController::TestCase
  test "should get sitemap" do
    get :sitemap
    assert_response :success
    assert_not_nil assigns(:pages)
  end
end
