class CreateCardLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :card_likes do |t|

      t.timestamps
    end
    add_reference :card_likes, :edtracker, index: true
    add_reference :card_likes, :myedtool, index: true
    add_reference :card_likes, :user, index: true
  end
end
