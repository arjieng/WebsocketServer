class AddGroupIdToPrayer < ActiveRecord::Migration[5.2]
  def up
  	add_column :prayers, :group_id, :integer
  	add_index :prayers, ['group_id'], :name => 'index_group_id'
  end
  def down
  	remove_column :prayers, :group_id
  end
end
