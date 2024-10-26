# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require_relative '../data/schema'

module ManualPinArchiver
  extend Discordrb::EventContainer

  application_command(:archive) do |event|
    event.defer(ephemeral: true)
    pins = event.channel.pins

    if pins.count == 50 && archiver_records(server: event.server.id, type: :check)
      archive_channel = event.bot.channel(archiver_records(server: event.server.id, type: :get))
      message = pins[1]

      if message.attachments.any?
        archive_channel.send_embed do |embed|
          embed.colour = UI[2]
          embed.description = message.content.to_s
          embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments[0].url.to_s)
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.display_name, url: message.link.to_s, icon_url: message.author.avatar_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{time_data(message.timestamp.to_s)}")
          embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        end

      else
        archive_channel.send_embed do |embed|
          embed.colour = UI[2]
          embed.description = message.content.to_s
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.display_name, url: message.link.to_s, icon_url: message.author.avatar_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{message.id} • #{resolve_time(message.timestamp.to_s)}")
          embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        end
      end
      message.unpin
      event.edit_response(content: "#{RESPONSE[20]} #{EMOJI[3]}")
    end
  end
end
