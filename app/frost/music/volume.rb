# frozen_string_literal: true

def music_volume(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[71])
    return
  end

  unless CALLIOPE.players[data.server.id]
    data.edit_response(content: RESPONSE[82])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.edit_response(content: RESPONSE[75])
    return
  end

  CALLIOPE.players[data.server.id].volume = data.options['volume']

  data.edit_response(content: RESPONSE[80])
end
