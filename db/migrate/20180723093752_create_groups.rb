class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :group_code
      t.string :group_name
      t.string :group_image
      t.timestamps
    end
  end
end
