require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  test "invalid with empty attributes" do
    comment = Comment.new
    assert !comment.valid?, "Validated invalid record"
    assert comment.errors.invalid?(:network_id)
    assert comment.errors.invalid?(:body)
    assert_equal I18n.translate('activerecord.errors.messages')[:blank], comment.errors.on(:network_id)
    assert_equal I18n.translate('activerecord.errors.messages.too_short', :count =>1), comment.errors.on(:body)
    assert !comment.save, "Saved invalid comment"
  end  
  
end
