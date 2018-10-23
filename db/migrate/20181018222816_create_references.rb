class CreateReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :references do |t|
      t.string :name
      t.references :note, foreign_key: true

      t.timestamps
    end
  end
end
