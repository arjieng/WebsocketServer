class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController
	def create
		if params[:user].present?
			@user = User.find_by(username: params[:username])
		    if @user.nil?
		    	group = Group.find_by(group_code: params[:user][:group_code])
				if group.nil?
					render json: { error: "Group does not exist.", status: 404 }, status: 400
				else
					user = User.create(user_params)

					client_id = SecureRandom.urlsafe_base64(nil, false)
					token     = SecureRandom.urlsafe_base64(nil, false)
					user.tokens[client_id] = {
						token: BCrypt::Password.create(token),
						expiry: (Time.now + user.token_lifespan).to_i
					}
					new_auth_header = user.build_auth_header(token, client_id)
					response.headers.merge!(new_auth_header)

					group_member = group.group_members.create(user_id: user.id, role: 2)
					group_member.save!
					if user.save!
						render json: { data: { role: group_member.role, user: user.as_json(only: [:id, :first_name, :last_name, :email, :address, :birthdate, :city, :zip, :state, :phone_number, :gender, :username, :avatar]), group: group.as_json(only: [:id, :group_code, :group_name, :group_image]) }, status: 200 }, status: 200
					else
						render json: { error: "Account not created.", status: 404 }, status: 400
					end
				end
		    else
				render json: { error: "Username already exist.", status: 404 }, status: 400
		    end
			
		elsif params[:user_admin].present?
			@user = User.find_by(username: params[:username])
		    if @user.nil?
				user = User.create(admin_params)
				client_id = SecureRandom.urlsafe_base64(nil, false)
				token     = SecureRandom.urlsafe_base64(nil, false)
				user.tokens[client_id] = {
					token: BCrypt::Password.create(token),
					expiry: (Time.now + user.token_lifespan).to_i
				}
				new_auth_header = user.build_auth_header(token, client_id)
				response.headers.merge!(new_auth_header)
				if user.save!
					group_params = params[:user_admin][:group]
					group = Group.create(group_name: group_params[:group_name])
					if group.save!

					  group_admin = group.group_members.create(user_id: user.id, role: 1)
					  group_admin.save!
					  render json: { data: { role: group_admin.role, user: user.as_json(only: [:id, :first_name, :last_name, :email, :address, :birthdate, :city, :zip, :state, :phone_number, :gender, :username, :avatar]), group: group.as_json(only: [:id, :group_code, :group_name, :group_image]) }, status: 200 }, status: 200
					end
				else
					render json: { error: "Account not created.", status: 404 }, status: 400
				end
			else
				render json: { error: "Username already exist.", status: 404 }, status: 400
			end
		end
	end

	protected
		def admin_params
			params.require(:user_admin).permit(:email, :password, :username)
		end
		def user_params
			params.require(:user).permit(:email, :password, :username)
		end
end
