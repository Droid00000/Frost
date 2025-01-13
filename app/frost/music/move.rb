# frozen_string_literal: true

def music_move(data)
  unless data.server.bot.permission?(:connect, data.channels("channel"))
    data.edit_response(content: RESPONSE[99])
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

  gateway_voice_move(data)

  data.edit_response(content: RESPONSE[100])
end
