# frozen_string_literal: true

def music_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[71])
    return
  end

  track = CALLIOPE.search(data.options["track"])

  begin
    gateway_voice_connect(data)
  rescue StandardError
    data.edit_response(content: RESPONSE[73])
    return
  end

  begin
    CALLIOPE.play_track(data.server.id, track)
  rescue ArgumentError
    data.edit_response(content: RESPONSE[72])
    return
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[5]
      embed.url = track.source
      embed.title = "#{track.name} — #{track.artist}"
      embed.description = format(EMBED[141], track.strftime)
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: CALLIOPE.status(track))
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: format(EMBED[142], data.user.display_name), icon_url: data.user.avatar_url)
    end
  end
end
