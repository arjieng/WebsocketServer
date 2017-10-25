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
                EM::WebSocket.run(:host => '0.0.0.0', :port => ENV['PORT'] || 8080) do |ws|
                    ws.onopen { |hs|
                        sid = @channel.subscribe { |msg| ws.send msg }
                        timer = EM.add_periodic_timer(30){
                            p [sid, ws.ping('hello')]
                        }


                        ws.onmessage { |msg|
                            parsed = JSON.parse(msg)
                            if !parsed["new_connection"].nil?
                                @channel.push "{ \"new_connection\": { \"sid\": #{sid}, \"aid\": #{parsed["new_connection"]["aid"]} } }"
                            end
                            # @channel.push "{\"id\": #{sid}, \"latitude\": \"#{parsed["latitude"]}\", \"longitude\": \"#{parsed["longitude"]}\" }"
                        }

                        ws.onclose{
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