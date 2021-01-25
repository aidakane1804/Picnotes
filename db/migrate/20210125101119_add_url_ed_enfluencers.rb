class AddUrlEdEnfluencers < ActiveRecord::Migration[5.2]
  def change
  	add_column :ed_fluencers, :url, :string
  end
end
