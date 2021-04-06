class CreateEdtrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :edtrackers do |t|
      t.string :edtracker_type
      t.string :topic
      t.string :category
      t.text :card_likes
      t.string :hashtag

      t.timestamps
    end
  end
end
