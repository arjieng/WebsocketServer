class CreateChatroomMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :chatroom_messages do |t|
      t.belongs_to :user
      t.belongs_to :chatroom
      t.timestamps
    end
  end
end
