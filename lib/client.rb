class Client
  attr_accessor :username, :ip, :socket

  def initialize socket
    @socket = socket
    @username = "Guest-"+Time.now.strftime("%s")
  end
end
