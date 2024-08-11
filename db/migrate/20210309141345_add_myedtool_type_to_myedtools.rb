class AddMyedtoolTypeToMyedtools < ActiveRecord::Migration[5.2]
  def change
    add_column :myedtools, :myedtool_type, :string
  end
end
