class AddUserToEdtrackers < ActiveRecord::Migration[5.2]
  def change
    add_reference :edtrackers, :user, foreign_key: true
  end
end
