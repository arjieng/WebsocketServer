class RenameColumnTypeToChatroomTypeInChatroom < ActiveRecord::Migration[5.2]
  def up
  	rename_column :chatrooms, :type, :chatroom_type
  end

  def down
  	rename_column :chatrooms, :chatroom_type, :type
  end
end
