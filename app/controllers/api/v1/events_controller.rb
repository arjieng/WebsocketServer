class Api::V1::EventsController < ApplicationController
	before_action :authenticate_user!, only: [:create, :index, :update]
	before_action :authorize_user!, only: [:create, :index, :update]

	def get_attendees
		attendees = Attendee.includes(:user).where(event_id: params[:event_id]).limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_attendees = Attendee.where(event_id: params[:event_id]).count

		@attendees = []
		attendees.each do |attendee|
			@attendees.push(attendee.user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :zip, :state, :phone_number, :gender, :username, :avatar]))
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10
		@paginate = {
			load_more: total_attendees > off_set ? 1 : 0,
			url: "/api/attendees?event_id=#{params[:event_id]}&off_set=#{off_set}" 
		}
		render json: { attendees: @attendees, load_more: @paginate, status: 200 }, status: 200
	end

	def add_attendee
		attendee = Attendee.includes(:user).create(event_id: params[:event_id], user_id: params[:user_id])
		render json: { attendee: attendee.user.as_json(only: [:id, :first_name, :last_name, :email, :address, :city, :zip, :state, :phone_number, :gender, :username, :avatar]), status: 200 }, status: 200
	end

	def remove_attendee
		attendee = Attendee.where(event_id: params[:event_id], user_id: params[:user_id]).first #().destroy_all
		if attendee.present?
			attendee.delete
			render json: { removed: attendee.destroyed?, status: 200 }, status: 200
		end		
	end


	def index
		@events = Event.where(group_id: params[:group_id]).order("id DESC").limit(10).offset((params[:off_set].present? ? params[:off_set] : 0))
		total_events = Event.where(group_id: params[:group_id]).count

		events = []
		@events.each do |event|
			events.push(event.as_json(only: [:title, :details, :link, :created_at]))
		end

		off_set = (params[:off_set].present? ? params[:off_set].to_i : 0) + 10
		@paginate = {
			load_more: total_events > off_set ? 1 : 0,
			url: "/api/all_events?group_id=#{params[:group_id]}&off_set=#{off_set}"
		}

		render json: { events: events, load_more: @paginate, status: 200 }, status: 200
	end

	def update
		event = Event.find params[:event][:event_id]
		event.update_attributes(event_params)
		render json: { event: event.as_json(only: [:id, :title, :details, :link, :created_at]), status: 200 }, status: 200
	end

	def create
		event = Event.create(event_params)
		if event.save!
			render json: { event: event.as_json(only: [:id, :title, :details, :link, :created_at]), status: 200 }, status: 200
		end
	end

 	protected
 		def event_params
			params.require(:event).permit(:group_id, :title, :details, :link, :image)
		end
end