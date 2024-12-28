# frozen_string_literal: true

def music_resume(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[71])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.edit_response(content: RESPONSE[])
    return
  end

  unless CALLIOPE.player(data.server.id).idle?
    data.edit_response(content: RESPONSE[])
    return
  end

  CALLIOPE.player(data.server.id).paused = false

  data.edit_response(content: RESPONSE[])
end
