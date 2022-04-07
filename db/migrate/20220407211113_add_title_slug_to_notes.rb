class AddTitleSlugToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :title_slug, :string, null: true,:after => :title
  end
end
