class RemoveBoardsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :boards, force: :cascade
  end
end
