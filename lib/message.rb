require_relative 'client'
require_relative 'actions'
require 'cgi'

class Message
  attr_accessor :client, :content

  def self.parse(client, content)
    if Actions.is_action?(content)
      return Actions.parse(content, client)
    else
      return new.format(client, content) 
    end
  end

  def system_message content
    content = CGI.escapeHTML(content)
    "<div class='notice'><div class='clear'><div class='message_content'>"+content+"</div></div></div>"
  end

  def format client, content
    content = CGI.escapeHTML(content)
    "<div class='message'><div class='clear'><div class='user'>"+client.username+" says:</div><div class='message_content'>"+content+"</div></div></div>"
  end
end
