class CreateChatrooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chatrooms do |t|
      t.belongs_to :group
      t.string :chatroom_name
      t.string :chatroom_image
      t.integer :type
      t.timestamps
    end
  end
end
