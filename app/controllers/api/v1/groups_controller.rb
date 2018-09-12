class Api::V1::GroupsController < ApplicationController
	before_action :authenticate_user!, only: [:member_list, :get_chatrooms]
	before_action :authorize_user!, only: [:member_list, :get_chatrooms]

	def check_group
		group = Group.find_by_group_code params["group_code"]
		if group.present?
			render json: { group: group.as_json(only: [ :id, :group_code, :group_name, :group_image ]), status: 200 }, status: 200
		else
			render json: { error: { message: "This group does not exist." }, status: 404 }, status: 200
		end
	end

	def get_chatrooms
		group = Group.includes(chatrooms: :chatroom_messages).find_by_group_code params["group_code"]
		if group.present?
			@chatrooms = []
			group.chatrooms.each do |chatroom|
				if params["gender"].to_s == "Male"
					if(chatroom.chatroom_type != 1)
						@chatrooms.push({ id: chatroom.id, group_id: chatroom.group_id, chatroom_name: chatroom.chatroom_name, chatroom_image: chatroom.chatroom_image, chatroom_type: chatroom.chatroom_type, last_message: (chatroom.chatroom_messages.last).present? ? chatroom.chatroom_messages.last.body : nil })
					end
				else
					if(chatroom.chatroom_type != 2)
						@chatrooms.push({ id: chatroom.id, group_id: chatroom.group_id, chatroom_name: chatroom.chatroom_name, chatroom_image: chatroom.chatroom_image, chatroom_type: chatroom.chatroom_type, last_message: (chatroom.chatroom_messages.last).present? ? chatroom.chatroom_messages.last.body : nil })
					end
				end
			end
			render json: { groups: @chatrooms, status: 200 }, status: 200
		else
			render json: { error: { message: "This group does not exist." }, status: 404 }, status: 200
		end
	end

	def member_list
		group = Group.includes(group_members: [:user]).find_by_group_code params[:group_id]

		@group_members = []
		me_role = (group.group_members.find_by_user_id(current_user.id)).role
		@group_members.push({ id: current_user.id, first_name: current_user.first_name, last_name: current_user.last_name, email: current_user.email, address: current_user.address, city: current_user.city, zip: current_user.zip, state: current_user.state, phone_number: current_user.phone_number, gender: current_user.gender, username: current_user.username, avatar: current_user.avatar, birth_date: current_user.birth_date, role: me_role })
		group.group_members.each do |group_member|
			@group_member = group_member.user
			if(@group_member.id != current_user.id)
				@group_members.push({ id: @group_member.id, first_name: @group_member.first_name, last_name: @group_member.last_name, email: @group_member.email, address: @group_member.address, city: @group_member.city, zip: @group_member.zip, state: @group_member.state, phone_number: @group_member.phone_number, gender: @group_member.gender, username: @group_member.username, avatar: @group_member.avatar, role: group_member.role, birth_date: @group_member.birth_date })
			end
		end

		render json: { group_members: @group_members, status: 200 }, status: 200
	end
end





















