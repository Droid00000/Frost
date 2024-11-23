# frozen_string_literal: true

def unfreeze_server(data)
  unless data.bot.profile.on(data.server).permission?(:manage_channels)
    data.edit_response(content: RESPONSE[62])
    return
  end

  data.server.channels.each do |channel|
    channel.define_overwrite(data.server.everyone_role, nil, nil, reason: REASON[10])
  end

  unless safe_name?(data.options['reason'])
    data.edit_response(content: RESPONSE[49])
    return
  end

  data.edit_response(content: RESPONSE[48])
end
