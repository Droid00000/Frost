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

  members = data.options["members"].scan(REGEX[4]).uniq.reject do |member|
    data.server.member(member).hierarchy >= data.user.hierarchy
  end

  members = members.reject do |member|
    data.server.bot.hierarchy <= data.server.member(member).hierarchy
  end

  if members.empty?
    data.edit_response(content: RESPONSE[54])
    return
  end

  if members.include?(data.server.bot.id.to_s)
    members.delete(data.server.bot.id.to_s)
  end

  if members.include?(data.user.id.to_s)
    members.delete(data.user.id.to_s)
  end

  members.map(&:to_i).each_slice(200).to_a

  bans = members.map do |users|
    data.server.bulk_ban(users, data.options["messages"], data.options["reason"])
  end

  data.edit_response(content: format(RESPONSE[53], bans.count))
end
