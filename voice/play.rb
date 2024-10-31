# frozen_string_literal: true

require 'thread'
require 'discordrb'
require 'shellwords'
require 'data/lavalink'
require 'data/constants'

def voice_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  embed_author = data.bot.voice(data.server.id) ? "Queued" : (embed_author || "Now Playing")
  track = LAVALINK.resolve(data.options['url'])
  queue = Queue.new; queue << track

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = "#{track.name} — #{track.artist}"
      embed.colour = UI[5]
      embed.url = track.source
      embed.description = "**Duration:** `#{track.duration}`"
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: embed_author)
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{data.user.display_name}", icon_url: data.user.avatar_url)
    end
  end

  data.bot.voice_connect(data.user.voice_channel)

  until queue.empty?
    track = queue.pop
    data.bot.voice(data.server).play_io(IO.popen("yt-dlp -q -o - #{Shellwords.escape(track.playback)}"))
  end
end
