class CreateFlashcards < ActiveRecord::Migration[5.2]
  def change
    create_table :flashcards do |t|
      t.string :title
      t.text :question
      t.text :answer
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
