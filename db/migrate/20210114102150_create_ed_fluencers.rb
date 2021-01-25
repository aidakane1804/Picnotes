class CreateEdFluencers < ActiveRecord::Migration[5.2]
  def change
    create_table :ed_fluencers do |t|
      t.string :title
    	t.string :first_name
    	t.string :last_name
    	t.text   :content
      t.string :facebook
      t.string :twitter
      t.string :linkedIn
      t.string :website
    	t.string :image
    	t.text :article 
      t.timestamps
    end
  end
end
