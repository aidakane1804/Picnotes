class AddArchivedToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :archived, :boolean,default: false
  end
end