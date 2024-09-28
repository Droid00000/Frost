# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'

module AutoPinArchiver
  extend Discordrb::EventContainer

  unknown(type: :CHANNEL_PINS_UPDATE) do |event|
    channel = event.bot.channel(event.data['channel_id']&.to_i, server = event.data['guild_id']&.to_i)
    pins = channel.pins

    if pins.count == 50 && archiver_records(server: event.data['guild_id']&.to_i, type: :check)
      archive_channel = archiver_records(server: event.data['guild_id']&.to_i, type: :get)
      message = pins[1]

      if message.attachments.any?
        archive_channel.send_embed do |embed|
          embed.colour = UI[22]
          embed.description = message.content.to_s
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments[0].url.to_s)
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.username.to_s,
                                                              url: message.link.to_s, icon_url: message.author.avatar_url.to_s)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{time_data(message.timestamp.to_s)}")
          embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        end

      else
        archive_channel.send_embed do |embed|
          embed.colour = UI[22]
          embed.description = message.content.to_s
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.username.to_s,
                                                              url: message.link.to_s, icon_url: message.author.avatar_url.to_s)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{time_data(message.timestamp.to_s)}")
          embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        end
        message.unpin
      end
    end
  end
end
