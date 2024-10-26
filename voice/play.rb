# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require 'shellwords'
require 'discordrb'

def voice_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  unless resolve_song(data.options['url'])
    data.edit_response(content: RESPONSE[44])
    return
  end

  track = resolve_song(data.options['url'])

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = "#{track[1] || "Unknown Track"} — #{track[2] || "Artist Unknown"}"
      embed.colour = UI[5]
      embed.url = track[0] || data.options['url']
      embed.description = "**Duration:** `#{track[3] || "Duration Unavalible"}`"
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track[4] || UI[1])
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Now Playing")
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{data.user.display_name}", icon_url: data.user.avatar_url)
    end
  end

  data.bot.voice_connect(data.user.voice_channel)
  data.bot.voice(data.server).play_io(IO.popen("yt-dlp -q -o - #{Shellwords.escape(track[0] || data.options['url'])}"))
end
