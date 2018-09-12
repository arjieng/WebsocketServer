class ChatroomMessage < ApplicationRecord
	belongs_to :user
	belongs_to :chatroom
	mount_uploader :image, AvatarUploader
end
