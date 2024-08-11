class AddFollowStatusToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :follow_status, :boolean, default: false
  end
end
