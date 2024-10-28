# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/lavalink'
require 'shellwords'
require 'discordrb'

def voice_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  track = LAVALINK.resolve(data.options['url'])

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = "#{track.name} — #{track.artist}"
      embed.colour = UI[5]
      embed.url = track.source
      embed.description = "**Duration:** `#{track.duration}`"
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Now Playing")
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{data.user.display_name}",
                                                          icon_url: data.user.avatar_url)
    end
  end

  data.bot.voice_connect(data.user.voice_channel)
  data.bot.voice(data.server).play_io(IO.popen("yt-dlp -q -o - #{Shellwords.escape(track.playback)}"))
end
