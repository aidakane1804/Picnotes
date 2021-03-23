class AddUserToMyedtools < ActiveRecord::Migration[5.2]
  def change
    add_reference :myedtools, :user, foreign_key: true
  end
end
