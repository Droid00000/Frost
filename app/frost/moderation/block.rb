# frozen_string_literal: true

def block_member(data)
  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[49])
    return
  end

  if data.server.bot.id == data.options["member"]
    data.edit_response(content: RESPONSE[58])
    return
  end

  if data.user.id == data.options["member"]
    data.edit_response(content: RESPONSE[58])
    return
  end

  if data.member("member").hierarchy >= data.user.hierarchy
    data.edit_response(content: RESPONSE[58])
    return
  end

  overwrite = Discordrb::Overwrite.new(data.member("member"), deny: 1024)

  if data.options["cascade"] == true
    data.server.channels.each do |channel|
      next unless data.server.bot.permission?(:manage_roles, channel)

      channel.define_overwrite(overwrite, reason: REASON[12])
    end
  end

  if data.options["cascade"] == false
    data.channel.define_overwrite(overwrite, reason: REASON[12])
  end

  data.edit_response(content: format(RESPONSE[57], data.options["member"]))
end
