class Api::V1::UsersController < ApplicationController
	before_action :authenticate_user!, only: [:update_profile, :upload_user_avatar, :user_images, :update_account]
	before_action :authorize_user!, only: [:update_profile, :upload_user_avatar, :user_images, :update_account]
	# require "google/cloud/vision"
	
	def update_profile
		unless user_params.present?
	      raise ActionController::ParameterMissing "user"
	    end
		user = User.find params[:user][:id]
		if !user.nil?
			user.update_attributes user_params
			render json: { data: user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :birth_date, :zip, :state, :phone_number, :gender, :username, :avatar]), status: 200 }, status: 200
		end
	end

	def get_user_info
		user = User.find params[:id]
		if !user.nil?
			render json: { data: user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :birth_date, :zip, :state, :phone_number, :gender, :username, :avatar]), status: 200 }, status: 200
		else
			render json: { error: { message: "This user does not exist." }, status: 404 }, status: 200
		end
	end


	def update_account
		user_name = User.find_by_username params[:user][:username]
		if user_name.nil?
			if params[:user][:password].length < 8
				render json: { error: { message: "Password must be 8 characters." }, status: 404 }, status: 200
			else
				current_user.update_attributes(user_account_params)
				render json: { user: current_user.as_json(only: [:username]), status: 200 }, status: 200
			end
			
		else
			render json: { error: { message: "Username already exist" }, status: 404 }, status: 200
		end
	end

	def upload_user_avatar
		if !params[:user].present?
			render json: { error: { message: "Image not found." }, status: 404 }, status: 200
		else
			current_user.update_attributes(user_params)
			render json: { user: current_user.as_json(only: [:id, :first_name, :last_name, :email, :address, :birth_date, :city, :zip, :state, :phone_number, :gender, :username, :avatar]), status: 200 }, status: 200
		end
		
		# vision = Google::Cloud::Vision.new project: "server-140903"
		# image = vision.image params[:avatar]
		# render json: image
	end

	def user_images
		@images = []
		current_user.chatroom_messages.each do |message|
			@images.push(url: message.image)
		end

		render json: { user_images: @images, status: 200 }, status: 200
	end

	protected
		def user_account_params
			params.require(:user).permit(:username, :password)
		end
		def user_params
			params.require(:user).permit(:email, :phone_number, :first_name, :last_name, :address, :birth_date, :gender, :city, :zip, :state, :avatar)
		end
end

