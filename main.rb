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
require 'app'

require 'client'
require 'message'
require 'actions'

$clients = []

redis = Redis.new(:host => '127.0.0.1', :port => 6379)
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
      puts 'creating socket'
      client = Client.new(ws)
      $clients << client
      $clients.each do |client|
        client.socket.send "<div class='notice'>"+client.username+" has connected.</div>"
      end
    end

    ws.onclose do
      puts 'closing socket'
      $clients.each do |client|
        client.socket.send "<div class='alert'>"+client.username+" has left.</div>"
      end
      $clients.delete client
    end
  end
  Thin::Server.start App, '0.0.0.0', 3000
end



