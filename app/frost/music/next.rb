# frozen_string_literal: true

def music_next(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[71])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.edit_response(content: RESPONSE[75])
    return
  end

  if CALLIOPE.players[data.server.id].queue.empty?
    data.edit_response(content: RESPONSE[79])
    return
  end

  if CALLIOPE.players[data.server.id].paused?
    data.edit_response(content: RESPONSE[81])
    return
  end

  track = CALLIOPE.players[data.server.id].next

  data.edit_response do |builder, components|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.url = track.source
      embed.title = "#{track.name} — #{track.artist}"
      embed.description = format(EMBED[141], track.strftime)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: EMBED[147])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: format(EMBED[142], data.user.display_name),
                                                          icon_url: data.user.avatar_url)
    end
  end
end
