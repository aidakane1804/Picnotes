class AddBoardsToNotes < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :board, foreign_key: true
  end
end
