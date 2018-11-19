class AddGenderCdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :gender_cd, :integer
  end
end
