class AddCityStateZipInUser < ActiveRecord::Migration[5.2]
  def up
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :zip, :string
  end
  
  def down
  	remove_column :users, :city
  	remove_column :users, :state
  	remove_column :users, :zip
  end
end
