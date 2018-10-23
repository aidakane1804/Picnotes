class AddUserToNote < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :user, foreign_key: true
  end
end
