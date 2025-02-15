# frozen_string_literal: true

module Music
  # Skip to a track.
  def self.skip(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    unless CALLIOPE.players[data.server.id].queue
      data.edit_response(content: RESPONSE[79])
      return
    end

    index = data.options["index"] ? data.options["index"].to_s.delete(",").strip.to_i - 1 : 0

    if CALLIOPE.players[data.server.id].queue.size - 1 < index && !random
      data.edit_response(content: RESPONSE[102])
      return
    end

    if data.options["random"]
      track = CALLIOPE.players[data.server.id].play_random
    end

    unless data.options["random"]
      track = CALLIOPE.players[data.server.id].next(index, data.options["destructive"])
    end

    data.edit_response do |builder|
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
end
