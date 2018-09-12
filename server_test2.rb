require 'faye'
require 'eventmachine'
require 'logger'
require 'open-uri'
require 'net/http'
require 'json'

class ServerTest

  def initialize()
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG
    begin
      @client = Faye::Client.new('tcp://0.0.0.0:9292/faye')
    rescue
      @logger.error "Error initializing Faye client"
      exit
    end
  end

  def run
    EM.run {
      g = @client.subscribe("/example2") do |message|
        if message["action"] == "receive_message"
          puts "#{message.inspect} DAWAT NA"
        end
      end
      
      g.callback do |message|
        puts "callback: #{message.inspect}"
        @client.publish "/example2", {action: "send_message", data: { id: 111 }}
      end
    } 
  end
end

if __FILE__ == $0
  if ARGV.count < 0
    puts "Usage: ruby server_test.rb <user_id>"
    exit
  end

  user_id= ARGV[0]

  client = ServerTest.new
  # client.authenticate
  client.run
end