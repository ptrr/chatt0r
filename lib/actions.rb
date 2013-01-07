class Actions
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
    return "No action"
  end
end
