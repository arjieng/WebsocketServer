class Api::V1::MessagesController < ApplicationController
	before_action :authenticate_user!, only: [:inbox]
	before_action :authorize_user!, only: [:inbox]

	def inbox
		
	end
end