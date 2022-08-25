class AddImageSourceToReferences < ActiveRecord::Migration[5.2]
  def change
    add_column :references, :image_source, :text
  end
end
