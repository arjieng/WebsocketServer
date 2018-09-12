class ChangeStringToJsonInUser < ActiveRecord::Migration[5.2]
  def up
  	change_table :users do |t|
  		t.change :avatar, 'json USING CAST(avatar as json)'
  	end
  end

  def down
  	change_table :users do |t|
  		t.change :avatar, :string
  	end
  end
end
