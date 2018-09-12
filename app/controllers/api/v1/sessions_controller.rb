class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
    def create
    user = User.find_by(username: params[:username])
    
    if user.nil? || !user.valid_password?(params[:password])
      render json: { "error" => "Invalid Username / Password.", status: 404 }, status: 400
    else
      
      group = GroupMember.where("user_id = #{user.id} AND group_id = #{params[:group_id]}").first
      if group.nil?
        render json: { "error" => "Invalid Username / Password.", status: 404 }, status: 400
      else
        client_id = SecureRandom.urlsafe_base64(nil, false)
        token     = SecureRandom.urlsafe_base64(nil, false)

        user.tokens[client_id] = {
          token: BCrypt::Password.create(token),
          expiry: (Time.now + user.token_lifespan).to_i
        }

        new_auth_header = user.build_auth_header(token, client_id)

        response.headers.merge!(new_auth_header)
        user.save!
        render json: { data: { role: group.role, user: user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :birth_date, :zip, :state, :phone_number, :gender, :username, :avatar]) }, status: 200 }, status: 200
      end



      # client_id = SecureRandom.urlsafe_base64(nil, false)
      # token     = SecureRandom.urlsafe_base64(nil, false)

      # user.tokens[client_id] = {
      #   token: BCrypt::Password.create(token),
      #   expiry: (Time.now + user.token_lifespan).to_i
      # }

      # new_auth_header = user.build_auth_header(token, client_id)

      # response.headers.merge!(new_auth_header)

      # user.save!

      # render json: { data: user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :zip, :state, :phone_number, :gender, :username, :avatar]), status: 200 }, status: 200
    end
  end
end
