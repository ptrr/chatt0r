require_relative 'client'
require_relative 'actions'
class Message
  attr_accessor :client, :content
  def parse client, content
    return format(client, content) unless is_action?(content.split(" ").first)
    action, content = to_action content
    return Actions.new.send(action, client, content)
  end

  def to_action content
    action = content.split(" ").shift
    content = content.gsub(action, '') || ''
    [action.gsub('/', ''), content]
  end

  def is_action? content
    content =~ /\/\w+/
  end

  def format client, content
    "<div class='message'><div class='clear'><div class='user'>"+client.username+" says:</div><div class='message_content'>"+content+"</div></div></div>"
  end
end
