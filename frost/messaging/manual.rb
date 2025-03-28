# frozen_string_literal: true

module Pins
  # Archive all the pins in the current channel.
  def self.archive(data)
    unless data.server.bot.permission?(:manage_message, data.channel)
      data.edit_response(content: RESPONSE[1])
      return
    end

    unless data.channel.pins.count == 50
      data.edit_response(content: RESPONSE[2])
      return
    end

    unless Frost::Pins.get(data)
      data.edit_response(content: RESPONSE[6])
      return
    end

    channel = Frost::Pins.channel(data)
    pin = data.channel.pins[1]

    channel.send_embed(pin.link) do |embed|
      embed.colour = pin.author.color
      embed.timestamp = pin.timestamp
      embed.description = pin.content
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: pin.attachments.first.url) if pin.attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: pin.author.display_name, icon_url: pin.author.avatar_url)
    end

    data.edit_response(content: RESPONSE[4]) && pin.unpin
  end
end
