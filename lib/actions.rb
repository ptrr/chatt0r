require 'message'
class Actions
  def self.parse(content, client)
    params = content.split(" ") 
    action = params.shift[1..-1]
    new.send(action, client, *params)
  end

  def play(client, *args)
    "<div class='twelve columns alert-box secondary'>This will play a sound.</div>"
  end

  def username client, username=nil
    old_name = client.username
    if username
      client.username = username
      "<div class='twelve columns alert-box secondary'>#{old_name} is now known as #{username}</div>"
    else
      ""
    end
  end

  def users(*args)
    users = []
    $clients.each do |client|
      users << client.username
    end
    "<div class='twelve columns alert-box secondary'>In the room are: #{users.join(', ').to_s}</div>"
  end

  def method_missing(meth, *args, &block)
    Message.new.system_message("Command #{meth} does not exist.")
  end

  def self.is_action? content
    content =~ /^\/\w+/
  end
end
