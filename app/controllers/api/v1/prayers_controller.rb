class Api::V1::PrayersController < ApplicationController
	before_action :authenticate_user!, only: [:create, :answered_prayers, :unanswered_prayers, :index, :update, :add_prayer_comment, :prayer_comments, :get_all_prayers]
	before_action :authorize_user!, only: [:create, :answered_prayers, :unanswered_prayers, :index, :update, :add_prayer_comment, :prayer_comments, :get_all_prayers]
	def get_all_prayers
		@prayers_a = []
		@prayers_u = []
		prayers_a = Prayer.includes(:group, user: :group_members).where(group_id: params[:group_id], is_answered: 1).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_answered_prayer = Prayer.where(is_answered: 1, group_id: params[:group_id]).count

		prayers_u = Prayer.includes(:group, user: :group_members).where(group_id: params[:group_id], is_answered: 0).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_unanswered_prayer = Prayer.where(is_answered: 0, group_id: params[:group_id]).count

		prayers_a.each do |prayer|
			group_member = prayer.user
			if !group_member.nil?
				gm = group_member.group_members.find_by_group_id(params[:group_id])
				@prayers_a.push({ user: { role: gm.role, id: group_member.id, first_name: group_member.first_name, last_name: group_member.last_name, email: group_member.email, address: group_member.address, city: group_member.city, zip: group_member.zip, state: group_member.state, phone_number: group_member.phone_number, gender: group_member.gender, username: group_member.username, avatar: group_member.avatar, birth_date: group_member.birth_date }, id: prayer.id, subject: prayer.subject, details: prayer.details, answered_details: prayer.answered_details, is_answered: prayer.is_answered, share_to: prayer.share_to, is_hidden: prayer.is_hidden, created_at: prayer.created_at })
			end
		end

		prayers_u.each do |prayer|
			group_member = prayer.user
			if !group_member.nil?
				gm = group_member.group_members.find_by_group_id(params[:group_id])
				@prayers_u.push({ user: { role: gm.role, id: group_member.id, first_name: group_member.first_name, last_name: group_member.last_name, email: group_member.email, address: group_member.address, city: group_member.city, zip: group_member.zip, state: group_member.state, phone_number: group_member.phone_number, gender: group_member.gender, username: group_member.username, avatar: group_member.avatar, birth_date: group_member.birth_date }, id: prayer.id, subject: prayer.subject, details: prayer.details, answered_details: prayer.answered_details, is_answered: prayer.is_answered, share_to: prayer.share_to, is_hidden: prayer.is_hidden, created_at: prayer.created_at })
			end
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10

		@paginate_a = {
			load_more: total_answered_prayer > off_set ? 1 : 0,
			url: "/api/answered_prayers?off_set=#{off_set}&group_id=#{params[:group_id]}"
		}
		@paginate_u = {
			load_more: total_unanswered_prayer > off_set ? 1 : 0,
			url: "/api/unanswered_prayers?off_set=#{off_set}&group_id=#{params[:group_id]}"
		}
		render json: { answered: { prayers: @prayers_a, load_more: @paginate_a }, unanswered:{ prayers: @prayers_u, load_more: @paginate_u }, status: 200 }, status: 200
	end

	def answered_prayers
		@prayers = []
		prayers = Prayer.includes(user: :group_members).where(group_id: params[:group_id], is_answered: 1).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_answered_prayer = Prayer.where(is_answered: 1, group_id: params[:group_id]).count

		prayers.each do |prayer|
			group_member = prayer.user
			if !group_member.nil?
				gm = group_member.group_members.find_by_group_id(params[:group_id])
				@prayers.push({ user: { role: gm.role, id: group_member.id, first_name: group_member.first_name, last_name: group_member.last_name, email: group_member.email, address: group_member.address, city: group_member.city, zip: group_member.zip, state: group_member.state, phone_number: group_member.phone_number, gender: group_member.gender, username: group_member.username, avatar: group_member.avatar, birth_date: group_member.birth_date }, id: prayer.id, subject: prayer.subject, details: prayer.details, answered_details: prayer.answered_details, is_answered: prayer.is_answered, share_to: prayer.share_to, is_hidden: prayer.is_hidden, created_at: prayer.created_at })
			end
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10
		@paginate = {
			load_more: total_answered_prayer > off_set ? 1 : 0,
			url: "/api/answered_prayers?off_set=#{off_set}&group_id=#{params[:group_id]}"
		}
		render json: { prayers: @prayers, load_more: @paginate, status: 200 }, status: 200
	end

	def unanswered_prayers
		@prayers = []
		prayers = Prayer.includes(user: :group_members).where(group_id: params[:group_id], is_answered: 0).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_unanswered_prayer = Prayer.where(is_answered: 0, group_id: params[:group_id]).count
		
		prayers.each do |prayer|
			group_member = prayer.user
			if !group_member.nil?
				gm = group_member.group_members.find_by_group_id(params[:group_id])
				@prayers.push({ user: { role: gm.role, id: group_member.id, first_name: group_member.first_name, last_name: group_member.last_name, email: group_member.email, address: group_member.address, city: group_member.city, zip: group_member.zip, state: group_member.state, phone_number: group_member.phone_number, gender: group_member.gender, username: group_member.username, avatar: group_member.avatar, birth_date: group_member.birth_date }, id: prayer.id, subject: prayer.subject, details: prayer.details, is_answered: prayer.is_answered, share_to: prayer.share_to, is_hidden: prayer.is_hidden, created_at: prayer.created_at })
			end
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10
		@paginate = {
			load_more: total_unanswered_prayer > off_set ? 1 : 0,
			url: "/api/unanswered_prayers?off_set=#{off_set}&group_id=#{params[:group_id]}"
		}
		render json: { prayers: @prayers, load_more: @paginate, status: 200 }, status: 200
	end

	def index
		@prayers = []
		user = User.includes(:prayers).find params[:user_id]
		prayers = user.prayers.where(is_hidden: false).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_prayers = user.prayers.where(is_hidden: false).count

		prayers.each do |prayer|
			@prayers.push({ id: prayer.id, subject: prayer.subject, details: prayer.details, answered_details: prayer.answered_details, is_answered: prayer.is_answered, share_to: prayer.share_to, is_hidden: prayer.is_hidden, created_at: prayer.created_at })
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10
		@paginate = {
			load_more: total_prayers > off_set ? 1 : 0,
			url: "/api/prayers?user_id=#{params[:user_id]}&off_set=#{off_set}"
		}
		render json: { prayers: @prayers, load_more: @paginate, status: 200 }, status: 200
	end

	def update
		prayer = Prayer.includes(user: :group_members).find params[:prayer][:id]
		prayer.update_attributes(prayer_params)


		group_member = prayer.user
		if !group_member.nil?
			gm = group_member.group_members.find_by_group_id(params[:prayer][:group_id])
			render json: { prayer: { user: { role: gm.role, id: group_member.id, first_name: group_member.first_name, last_name: group_member.last_name, email: group_member.email, address: group_member.address, city: group_member.city, zip: group_member.zip, state: group_member.state, phone_number: group_member.phone_number, gender: group_member.gender, username: group_member.username, avatar: group_member.avatar, birth_date: group_member.birth_date }, id: prayer.id, subject: prayer.subject, details: prayer.details, answered_details: prayer.answered_details, is_answered: prayer.is_answered, share_to: prayer.share_to, is_hidden: prayer.is_hidden, created_at: prayer.created_at }, status: 200 }, status: 200
		end
		# render json: { prayer: prayer.as_json(only: [:id, :subject, :details, :answered_details, :is_answered, :share_to, :is_hidden, :created_at]), status: 200 }, status: 200
	end

	def create
		prayer = current_user.prayers.create(prayer_params)
		prayer.save!
		render json: { prayer: prayer.as_json(only: [:id, :subject, :details, :answered_details, :is_answered, :share_to, :is_hidden, :created_at]), status: 200 }, status: 200
	end

	def add_prayer_comment
		prayer = Prayer.find params[:comment][:prayer_id]
		comment = prayer.prayer_comments.create(prayer_comment_params)
		render json: { comment: comment.as_json(only: [:id, :comment, :created_at]), user: comment.user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :zip, :state, :phone_number, :gender, :username, :avatar]), status: 200 }, status: 200
	end

	def prayer_comments
		comments = PrayerComment.includes(:user).where(prayer_id: params[:prayer_id]).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		comment_count = PrayerComment.where(prayer_id: params[:prayer_id]).count
		
		@comments = []
		comments.each do |comment|
			@comments.push({ id: comment.id, comment: comment.comment, created_at: comment.created_at, user: comment.user.as_json(only: [:id, :first_name, :last_name, :email, :address, :birth_date, :city, :zip, :state, :phone_number, :gender, :username, :avatar]) })
			# @comments.push({ comment: comment.as_json(only: [:id, :comment, :created_at]), user: comment.user.as_json(only: [:id, :first_name, :last_name, :email, :address, :birth_date, :city, :zip, :state, :phone_number, :gender, :username, :avatar]) })
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10
		@paginate = {
			load_more: comment_count > off_set ? 1 : 0,
			url: "/api/prayer_comments?id=#{params[:prayer_id]}&off_set=#{off_set}"
		}
		render json: { comments: @comments, load_more: @paginate, status: 200}, status: 200	
	end

	def hide_prayer
		prayer = Prayer.find params[:prayer_id]
		prayer.update(is_hidden: true)
		render json: { prayer: prayer.as_json(only: [:id, :subject, :details, :answered_details, :is_answered, :share_to, :is_hidden, :created_at]), status: 200 }, status: 200
	end


	protected
		def prayer_params
			params.require(:prayer).permit(:subject, :details, :answered_details, :is_answered, :share_to, :is_hidden, :group_id)
		end
		def prayer_comment_params
			params.require(:comment).permit(:user_id, :comment)
		end
end