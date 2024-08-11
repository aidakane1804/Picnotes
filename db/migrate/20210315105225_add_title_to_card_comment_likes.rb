class AddTitleToCardCommentLikes < ActiveRecord::Migration[5.2]
  def change
    add_column :card_comment_likes, :title, :string
  end
end
