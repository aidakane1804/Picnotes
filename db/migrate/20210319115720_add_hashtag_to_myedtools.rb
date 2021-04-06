class AddHashtagToMyedtools < ActiveRecord::Migration[5.2]
  def change
    add_column :myedtools, :hashtag, :string
  end
end
