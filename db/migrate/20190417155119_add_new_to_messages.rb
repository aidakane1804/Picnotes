class AddNewToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :new, :boolean
  end
end
