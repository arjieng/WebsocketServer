class AddIsHiddenToPrayer < ActiveRecord::Migration[5.2]
  def up
  	add_column :prayers, :is_hidden, :boolean
  end
  
  def down
  	remove_column :prayers, :is_hidden
  end
end
