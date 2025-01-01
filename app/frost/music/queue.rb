# frozen_string_literal: true

def music_queue(data)
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
    data.edit_response(content: RESPONSE[81])
    return
  end

  unless CALLIOPE.players[data.server.id].lava_queue
    data.edit_response(content: RESPONSE[79])
    return
  end

  queue = [[], []]

  fetch_queue(data, :BOTTOM).each_with_index do |track, index|
    queue[1] << "#{track.name} by #{track.artist} —— **#{index + 1}**\n"
  end

  fetch_queue(data, :TOP).each_with_index do |track, index|
    queue[0] << "#{track.name} by #{track.artist} —— **#{index + 1}**\n"
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[6]
      embed.description = EMBED[150]
      embed.timestamp = Time.at(Time.now)
      embed.title = format(EMBED[149], data.server.name)
      embed.add_field(name: EMBED[151], value: queue[0].join, inline: true)
      embed.add_field(name: EMBED[152], value: queue[1].join, inline: true)
    end
  end
end
