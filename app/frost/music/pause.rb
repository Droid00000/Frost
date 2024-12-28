# frozen_string_literal: true

def music_pause(data)
  if data.user.voice_channel.nil?
    data.send_message(content: RESPONSE[71])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.send_message(content: RESPONSE[])
    return
  end

  if CALLIOPE.player(data.server.id).idle?
    data.send_message(content: RESPONSE[])
    return
  end

  CALLIOPE.player(data.server.id).paused = true

  data.send_message(content: RESPONSE[])
end
