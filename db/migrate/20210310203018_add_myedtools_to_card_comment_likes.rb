class AddMyedtoolsToCardCommentLikes < ActiveRecord::Migration[5.2]
  def change
    add_reference :card_comment_likes, :myedtool, foreign_key: true
  end
end
