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

  unless CALLIOPE.players[data.server.id].queue
    data.edit_response(content: RESPONSE[79])
    return
  end

  queue = [[], []]

  fetch_queue(data, :BOTTOM).each_with_index do |track, index|
    queue[0] << "**#{index + 1}** — [#{track.name}](#{track.url})\n"
  end

  fetch_queue(data, :TOP).each_with_index do |track, index|
    queue[1] << "**#{index + 1}** — [#{track.name}](#{track.url})\n"
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.timestamp = Time.now
      embed.title = format(EMBED[149], data.server.name)
      embed.description = format(EMBED[150], fetch_queue(data, :ALL))
      embed.add_field(name: EMBED[151], value: queue[0].join, inline: true)
      embed.add_field(name: EMBED[152], value: queue[1].join, inline: true)
    end
  end
end
