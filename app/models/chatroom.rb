class Chatroom < ApplicationRecord
	belongs_to :group
	has_many :chatroom_messages
end
