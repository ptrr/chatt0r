$:.unshift(File.expand_path('../lib', __FILE__))
$:.unshift(File.expand_path('../web', __FILE__))

require 'rubygems'      # <-- Added this require
require 'em-websocket'
require 'sinatra/base'
require 'thin'
require 'haml'
require 'redis'
require 'socket'
require 'json'
require './app' 

require './lib/client'
require './lib/message'
require './lib/actions'

$clients = []

redis = Redis.new(:host => '127.0.0.1', :post => 6379)
puts redis.methods.inspect
EM.run do


  EM::WebSocket.start(:host => '0.0.0.0', :port => 3001) do |ws|
    client ||= nil
    ws.onmessage do |msg|
      msg = Message.new.parse(client, msg)
      ws.send(msg)
      $clients.each do |client|
        if ws != client.socket
          client.socket.send(msg)
        end
      end
    end

    ws.onopen do
      # When someone connects I want to add that socket to the $clients array that
      # I instantiated above
      puts 'creating socket'
      client = Client.new(ws)
      $clients << client
      $clients.each do |client|
        client.socket.send "client_connect" + $clients.to_json
        client.socket.send client.username+" has connected."
      end
      puts $clients.inspect
    end

    ws.onclose do
      # Upon the close of the connection I remove it from my list of running sockets
      puts 'closing socket'
      $clients.delete client
    end
  end

  # You could also use Rainbows! instead of Thin.
  # Any EM based Rack handler should do.
  Thin::Server.start App, '0.0.0.0', 3000
end

