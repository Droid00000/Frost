# frozen_string_literal: true

module PinArchiver
  extend Discordrb::EventContainer

  application_command(:archive) do |event|
    event.defer(ephemeral: true)
    pins = event.channel.pins

    if pins.count == 50 && Frost::Pins.get?(event)
      channel = event.bot.channel(Frost::Pins.get(event))
      message = pins[1]

      channel.send_embed do |embed|
        embed.colour = UI[2]
        embed.timestamp = message.timestamp
        embed.description = message.content&.to_s
        embed.add_field(name: 'Source', value: "[Jump!](#{message.link})")
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: message.attachments.first.url) if message.attachments.any?
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: message.author.display_name, icon_url: message.author.avatar_url)
      end
      message.unpin
      event.edit_response(content: "#{RESPONSE[20]}")
    end
  end
end
