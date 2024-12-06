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

  unless safe_name?(data.options['reason'])
    data.edit_response(content: RESPONSE[49])
    return
  end

  members = data.options['members'].scan(REGEX[4]).split.uniq.reject do |member|
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

  members.pop while members.size > 200

  bans = data.server.bulk_ban(members, data.options['messages'], data.options['reason'])

  data.edit_response(content: RESPONSE[53] % bans.count)
end
