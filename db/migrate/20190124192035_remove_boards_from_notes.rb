class RemoveBoardsFromNotes < ActiveRecord::Migration[5.2]
  def change
    remove_column :notes, :board_id
  end
end
