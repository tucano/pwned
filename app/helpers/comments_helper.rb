module CommentsHelper
  def comments_title
    if @network then
      "Comments for #{@network.name}"
    else
      "Comments: all"
    end
  end
end
