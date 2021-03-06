class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username, index: {unique: true}
      t.string :email, index: {unique: true}
      t.string :password_digest
      t.string :city
      t.string :date_of_birth

      t.timestamps
    end
  end
end
