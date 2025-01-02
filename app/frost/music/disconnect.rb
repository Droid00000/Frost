# frozen_string_literal: true

def music_disconnect(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[71])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.edit_response(content: RESPONSE[75])
    return
  end

  unless CALLIOPE.players[data.server.id]
    data.edit_response(content: RESPONSE[82])
    return
  end

  gateway_voice_disconnect(data)

  CALLIOPE.delete_player(data.server.id)

  data.edit_response(content: RESPONSE[87])
end
