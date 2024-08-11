class AddLinkToEdtrackers < ActiveRecord::Migration[5.2]
  def change
    add_column :edtrackers, :link, :string
  end
end
