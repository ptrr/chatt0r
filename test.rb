module Actions
  def set_username params
    self.username = params[0]
    Server.broadcast("he changed")
  end
end

class Client
  include Actions
  attr_accessor :username

  def trigger(what, *params)
    send(what, params) if Actions.instance_methods.include?(what)
  end

end

class Server
  def self.broadcast(what)
    p what
  end
end

ronald = Client.new
ronald.trigger(:set_username, "ploedploe")

