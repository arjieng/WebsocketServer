require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebsocketApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    if defined?(Rails::Server)
        config.after_initialize do 
            require 'em-websocket'
            
            EM.run{
                @channel = EM::Channel.new
                @connected = []
                @disconnected = []
                EM::WebSocket.run(:host => '0.0.0.0', :port => ENV['PORT'] || 8080) do |ws|
                    ws.onopen {
                        myId = nil
                        sid = @channel.subscribe { |msg| ws.send msg }
                        @connected.push sid
                        puts @connected.to_s
                        puts @disconnected.to_s
                        timer = EM.add_periodic_timer(30){
                            p [sid, ws.ping('hello')]
                        }


                        ws.onmessage { |msg|
                            parsed = JSON.parse(msg)
                            if parsed["new_connection"].present?
                                myId = parsed["new_connection"]["aid"]
                            end

                            if parsed["new_position"].present?
                                @channel.push "{ \"new_position\": { \"sid\": #{sid}, \"aid\": #{parsed["new_position"]["aid"]}, \"latitude\": #{parsed["new_position"]["latitude"]}, \"longitude\": #{parsed["new_position"]["longitude"]} } }"
                            end

                            if parsed["request_id"].present?
                                @channel.push "{ \"myId\": \"#{myId}\" }"
                            end
                        }

                        ws.onclose{
                            @disconnected.drop sid
                            @channel.push "{ \"remove_connection\": \"#{sid}\" }"
                            @channel.unsubscribe(sid)
                            EM.cancel_timer(timer)
                        }
                    }
                end
            }
        end
    end
  end
end