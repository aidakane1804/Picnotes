class CreateFoldersNotesJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :folders, :notes
  end
end
