class AddNotesToEdtracker < ActiveRecord::Migration[5.2]
  def change
    add_column :edtrackers, :notes, :text
  end
end
