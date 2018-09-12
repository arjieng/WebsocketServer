class GroupMember < ApplicationRecord
	belongs_to :group, foreign_key: "group_id", class_name: "Group"
	belongs_to :member, foreign_key: "user_id", class_name: "User"
	belongs_to :user
end
