class CreateMyedtools < ActiveRecord::Migration[5.2]
  def change
    create_table :myedtools do |t|
      t.string :addtitle
      t.string :chooseacategory
      t.text :notes
      t.string :link

      t.timestamps
    end
  end
end
