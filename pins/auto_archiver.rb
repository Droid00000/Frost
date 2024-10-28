# frozen_string_literal: true

require 'data/schema'
require 'data/constants'
require 'data/functions'

module AutoPinArchiver
  extend Discordrb::EventContainer

  unknown(type: :CHANNEL_PINS_UPDATE) do |event|
    channel = event.bot.channel(event.data['channel_id']&.to_i, event.data['guild_id']&.to_i)
    pins = channel.pins

    if pins.count == 50 && archiver_records(server: event.data['guild_id']&.to_i, type: :check)
      archive_channel = event.bot.channel.(archiver_records(server: event.data['guild_id']&.to_i, type: :get))
      message = pins[1]

      if message.attachments.any?
        archive_channel.send_embed do |embed|
          embed.colour = UI[2]
          embed.description = message.content.to_s
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments[0].url.to_s)
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.display_name, url: message.link, icon_url: message.author.avatar_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{time_data(message.timestamp.to_s)}")
          embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        end

      else
        archive_channel.send_embed do |embed|
          embed.colour = UI[2]
          embed.description = message.content.to_s
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.display_name, url: message.link, icon_url: message.author.avatar_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{resolve_time(message.timestamp.to_s)}")
          embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        end
      end
      message.unpin
    end
  end
end
