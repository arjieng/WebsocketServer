class AddImageToEvent < ActiveRecord::Migration[5.2]
  def up
  	add_column :events, :image, :json
  end
  
  def down
  	remove_column :events, :image
  end
end
