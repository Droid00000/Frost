# frozen_string_literal: true

def music_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = "#{track.name} — #{track.artist}"
      embed.colour = UI[5]
      embed.url = track.source
      embed.description = "**Duration:** `#{track.duration}`"
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: status)
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{data.user.display_name}", icon_url: data.user.avatar_url)
    end
  end
end
