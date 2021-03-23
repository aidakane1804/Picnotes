class AddBodyToCardCommentLikes < ActiveRecord::Migration[5.2]
  def change
    add_column :card_comment_likes, :body, :text
  end
end
