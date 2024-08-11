class ModifyFlashcards < ActiveRecord::Migration[5.2]
  def change
    change_table :flashcards do |t|
      t.remove :question, :answer
      t.text :flashcards, default: "{}"
    end
  end
end
