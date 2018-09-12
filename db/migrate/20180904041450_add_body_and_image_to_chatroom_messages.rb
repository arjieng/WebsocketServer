class AddBodyAndImageToChatroomMessages < ActiveRecord::Migration[5.2]
  def up
  	add_column :chatroom_messages, :image, :json
  	add_column :chatroom_messages, :body, :string
  end
  
  def down
  	remove_column :chatroom_messages, :image
  	remove_column :chatroom_messages, :body
  end
end
