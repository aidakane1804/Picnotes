class CreateReferences < ActiveRecord::Migration[5.1]
  def change
    create_table :references do |t|
      t.string :title
      t.string :author
      t.string :link
      t.references :note, foreign_key: true, index: true

      t.timestamps
    end
  end
end
