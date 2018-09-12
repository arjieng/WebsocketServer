class Group < ApplicationRecord
	has_many :group_members
	has_many :members, through: :group_members
	has_many :chatrooms
	has_many :prayers
	has_many :events
	after_create :generate_group_code
	after_create :create_groups
	private
		def generate_group_code
			secret = SecureRandom.alphanumeric(5)
			self.group_code = Group.find_by(group_code: secret.to_s) ? generate_group_code : secret
			self.save
		end

		def create_groups
			self.chatrooms.create(chatroom_name: "WOMEN ONLY", chatroom_type: 1)
			self.chatrooms.create(chatroom_name: "MEN ONLY", chatroom_type: 2)
			self.chatrooms.create(chatroom_name: "GROUP TEXT", chatroom_type: 3)
		end
end
# chatroom_name | chatroom_image | type