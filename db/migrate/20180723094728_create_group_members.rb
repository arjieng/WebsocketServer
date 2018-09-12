class CreateGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_members do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.integer :role
      t.timestamps
    end
  end
end
