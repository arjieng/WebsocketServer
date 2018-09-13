require 'faye'
require_relative 'lib/gospeltribe/gospel_tribes_authentication'

Faye::WebSocket.load_adapter('thin')
server = use Faye::RackAdapter, :mount => '/faye', :timeout => 25 do |bayeux|
	bayeux.add_extension(GospelTribesAuthentication.new)
	bayeux.bind(:handshake) do |client_id|
		puts "Bayeux:: Client #{client_id} connected"
	end
	bayeux.bind(:subscribe) do |client_id, channel|
		puts "Bayeux:: Client #{client_id} subscribed to #{channel}"
	end
	bayeux.bind(:unsubscribe) do |client_id, channel|
		puts "Bayeux:: Client #{client_id} unsubscribed from #{channel}"
	end
	bayeux.bind(:publish) do |client_id, channel, data|
		puts "Bayeux:: Client #{client_id} published to #{channel} with the datas #{data}"
	end
	bayeux.bind(:disconnect) do |client_id|
		puts "Bayeux:: Client #{client_id} disconnected"
	end
end

run server