# frozen_string_literal: true

def unfreeze_server(data)
  unless data.server.bot.permission?(:manage_channels)
    data.edit_response(content: RESPONSE[49])
    return
  end

  data.server.channels.each do |channel|
    channel.define_overwrite(data.server.everyone_role, nil, nil, reason: REASON[10])
  end

  data.edit_response(content: RESPONSE[41])
end
