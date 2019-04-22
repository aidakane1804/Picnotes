class AddRecevierIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :recevier_id, :integer
  end
end
