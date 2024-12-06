# frozen_string_literal: true

def unfreeze_server(data)
  unless data.server.bot.permission?(:manage_roles)
    data.edit_response(content: RESPONSE[49])
    return
  end

  data.server.channels.each do |channel|
    next unless data.server.bot.permission?(:manage_roles, channel)

    case channel.type
    when 0
      channel.destroy_overwrite(server.everyone_role, allow: 2048, reason: REASON[10])
    when 2
      channel.destroy_overwrite(server.everyone_role, allow: 3_147_776, reason: REASON[10])
    when 15
      channel.destroy_overwrite(server.everyone_role, allow: 377_957_124_096, reason: REASON[10])
    end
  end

  data.edit_response(content: RESPONSE[41])
end
