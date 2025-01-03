# frozen_string_literal: true

def bulk_ban(data)
  unless data.server.bot.permission?(:ban_members)
    data.edit_response(content: RESPONSE[51])
    return
  end

  unless data.server.bot.permission?(:manage_server)
    data.edit_response(content: RESPONSE[52])
    return
  end

  members = data.options["members"].scan(REGEX[4]).uniq.map(&:to_i).reject do |member|
    data.server.member(member).hierarchy >= data.user.hierarchy
  end

  members = members.reject do |member|
    data.server.bot.hierarchy <= data.server.member(member).hierarchy
  end

  if members.empty?
    data.edit_response(content: RESPONSE[54])
    return
  end

  [data.server.bot.id, data.user.id].each do |id|
    members.delete(id) if members.include?(id)
  end

  members.each_slice(200).to_a

  bans = members.map do |users|
    data.server.bulk_ban(users, data.options["messages"], data.options["reason"])
  end

  data.edit_response(content: format(RESPONSE[53], bans.count))
end
