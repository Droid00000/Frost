# frozen_string_literal: true

def music_seek(data)
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

  if CALLIOPE.players[data.server.id].paused?
    data.edit_response(content: RESPONSE[77])
    return
  end

  if CALLIOPE.players[data.server.id].track.nil?
    data.edit_response(content: RESPONSE[89])
    return
  end

  if REGEX[5].match(data.options["position"])
    m, s = data.options["position"].split(':').map(&:to_i)
    time = (m * 60) + s
  else
    begin
      time = Rufus::Scheduler.parse_duration(data.options["position"])
    rescue ArgumentError
      data.edit_response(content: RESPONSE[90])
      return
    end
  end

  if (time * 1000.0).to_i > CALLIOPE.players[data.server.id].track.duration
    data.edit_response(content: RESPONSE[91])
    return
  end

  CALLIOPE.players[data.server.id].position = (time * 1000.0).to_i

  data.edit_response(content: format(RESPONSE[92], Time.at(time).utc.strftime("%M:%S")))
end
