# frozen_string_literal: true

def music_disconnect(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[71])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.edit_response(content: RESPONSE[])
    return
  end

  unless CALLIOPE.player(data.server.id)
    data.edit_response(content: RESPONSE[])
    return
  end

  gateway_voice_disconnect(data)

  CALLIOPE.player(data.server.id).shutdown

  data.edit_response(content: RESPONSE[])
end
