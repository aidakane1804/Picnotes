class AddImageToNote < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :image, :string
  end
end
