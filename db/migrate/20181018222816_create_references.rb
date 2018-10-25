class CreateReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :references do |t|
      t.string :title
      t.string :lastName
      t.string :firstName
      t.string :publisher
      t.references :note, foreign_key: true

      t.timestamps
    end
  end
end
