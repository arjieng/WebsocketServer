require 'eventmachine'
require 'json'
require 'faye'
require 'logger'
require_relative '../../config/environment.rb'

class GospelTribesAuthentication
	def initialize
		@logger = Logger.new STDOUT	
		@faye_server = Faye::Client.new("tcp://192.168.2.123:8080/faye")
	end
	
	def incoming(message, callback)
		# puts "#{message.inspect}"
		if message["channel"] == "/meta/subscribe"
			# @logger.info "SUBSCRIBED"
		elsif message["channel"] == "/meta/unsubscribe"
			# @logger.info "UNSUSBSCRIBED"
		elsif message["channel"] == "/meta/disconnect"
			# @logger.info "DISCONNECTED"
		elsif message["channel"] == "/meta/handshake"
			# @logger.info "HANDSHAKE"
		elsif message["channel"] == "/meta/connect"

		else
			if message["data"]["action"] == "send_message"
				command = "#{message["data"]["action"]}_command"
				method(command).call(message["data"]["data"], message["channel"])
			end
		end
		callback.call(message)
	end

	def send_message_command(message, channel)
		data = { action: "receive_message", data: message }
		@faye_server.publish(channel, data)
	end
end