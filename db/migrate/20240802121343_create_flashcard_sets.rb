class CreateFlashcardSets < ActiveRecord::Migration[5.2]
  def change
    create_table :flashcard_sets do |t|
      t.string :title
      t.text :flashcard
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
