class AddNoteToCardCommentLike < ActiveRecord::Migration[5.2]
  def change
    add_reference :card_comment_likes, :note, foreign_key: true
  end
end
