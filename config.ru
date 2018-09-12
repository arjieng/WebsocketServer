# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application


# require_relative 'config/environment'
# require_relative 'config/initializers/subscription_monitor'


# use Faye::RackAdapter, :mount => '/faye', :timeout => 25 do |bayeux|
#   bayeux.add_extension(FayeAuthentication.new)
#   bayeux.add_extension(GameCreator.new)
#   bayeux.bind(:handshake) do |client_id|
#     puts "Bayeux:: Client #{client_id} connected"
#   end
#   bayeux.bind(:subscribe) do |client_id, channel|
#     puts "Bayeux:: Client #{client_id} subscribed to #{channel}"
#   end
#   bayeux.bind(:unsubscribe) do |client_id, channel|
#     puts "Bayeux:: Client #{client_id} unsubscribed from #{channel}"
#     SubscriptionMonitor.channel.push({
#       channel: channel,
#       client_id: client_id,
#       event: :unsubscribe
#     })
#   end
#   bayeux.bind(:disconnect) do |client_id|
#     puts "Bayeux:: Client #{client_id} disconnected"
#   end
# end
# run Rails.application