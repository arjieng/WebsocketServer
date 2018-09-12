class AddShareToInPrayer < ActiveRecord::Migration[5.2]
  def up
  	add_column :prayers, :share_to, :integer
  end
  
  def down
  	remove_column :prayers, :share_to
  end
end
