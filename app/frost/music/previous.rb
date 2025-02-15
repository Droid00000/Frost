# frozen_string_literal: true

module Music
  # Play the previous track.
  def self.previous(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    if CALLIOPE.players[data.server.id].paused?
      data.edit_response(content: RESPONSE[81])
      return
    end

    begin
      track = CALLIOPE.players[data.server.id].previous_track
    rescue StandardError
      data.edit_response(content: RESPONSE[88])
      return
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
