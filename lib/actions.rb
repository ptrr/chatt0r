require 'message'
class Actions
  def self.parse(content, client)
    params = content.split(" ") 
    action = params.shift[1..-1]
    new.send(action, client, *params)
  end

  def set_username client, username
    client.username = username
    "<div class='notice'>Username changed to #{username}</div>"
  end

  def show_users(*args)
    users = []
    $clients.each do |client|
      users << client.username
    end
    "<div class='notice'>#{users.join(', ').to_s}</div>"
  end

  def method_missing(meth, *args, &block)
    Message.new.system_message("Command #{meth} does not exist.")
  end

  def self.is_action? content
    content =~ /\/\w+/
  end
end
