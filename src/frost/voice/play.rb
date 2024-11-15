# frozen_string_literal: true

require 'lavalink'
require 'discordrb'
require 'constants'
require 'shellwords'

def voice_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:connect, data.user.voice_channel)
    data.edit_response(content: RESPONSE[63])
    return
  end

  unless data.bot.profile.on(data.server).permission?(:speak, data.user.voice_channel)
    data.edit_response(content: RESPONSE[64])
    return
  end

  track = LAVALINK.resolve(data.options['song'])

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = "#{track.name} — #{track.artist}"
      embed.colour = UI[5]
      embed.url = track.source
      embed.description = "**Duration:** `#{track.duration}`"
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: track.cover)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: data.bot.voice(data.server)&.playing? ? 'Queued' : 'Now Playing')
      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{data.user.display_name}",
                                                          icon_url: data.user.avatar_url)
    end
  end

  data.bot.voice_connect(data.user.voice_channel) if data.bot.voice(data.server).nil?
end
