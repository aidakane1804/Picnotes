class CreateCardCommentLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :card_comment_likes do |t|

      t.timestamps
    end
  end
end
