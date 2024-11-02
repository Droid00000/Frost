# frozen_string_literal: true

require 'discordrb'
require 'shellwords'
require 'data/lavalink'
require 'data/constants'

class Tracks
  # A Hash to store the current queue.
  @@track_queue = {}

  # @param queue [Queue]
  # @param server [Integer]
  def initialize(queue, server)
    @@track_queue[server.to_s] = Queue.new if @@track_queue[server.to_s].nil?
    @@track_queue[server.to_s] << queue
  end

  # Fetches the current queue from the cache.
  # @return [Queue] The current queue for the server.
  def self.queue(server)
    @@track_queue[server.to_s]
  end
end

def voice_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  track = LAVALINK.resolve(data.options['url'])
  Tracks.new(track.playback, data.server.id)

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = "#{track.name} — #{track.artist}"
      embed.colour = UI[5]
      embed.url = track.source
      embed.description = "**Duration:** `#{track.duration}`"
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: data.bot.voice(data.server)&.playing? ? 'Queued' : 'Now Playing')
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{data.user.display_name}", icon_url: data.user.avatar_url)
    end
  end

  data.bot.voice_connect(data.user.voice_channel)

  until Tracks.queue(data.server.id).empty?
    sleep 1 while data.bot.voice(data.server).playing?
    data.bot.voice(data.server).play_io(IO.popen("yt-dlp -q -o - #{Shellwords.escape(Tracks.queue(data.server.id).pop)}"))
  end
end
