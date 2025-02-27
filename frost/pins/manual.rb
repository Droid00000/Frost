# frozen_string_literal: true

module Pins
  # Archive all the pins in the current channel.
  def self.archive(data)
    unless data.channel.pins.count == 50
      data.edit_response(content: RESPONSE[127])
      return
    end

    unless Frost::Pins.get(data)
      data.edit_response(content: RESPONSE[128])
      return
    end

    channel, pin = Frost::Pins.channel(data), data.channel.pins[1]

    channel.send_embed do |embed|
      embed.colour = UI[2]
      embed.timestamp = pin.timestamp
      embed.description = pin.content
      embed.add_field(name: "Source", value: "[Jump!](#{pin.link})")
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: pin.attachments.first.url) if pin.attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: pin.author.display_name, icon_url: pin.author.avatar_url)
    end

    data.edit_response(content: RESPONSE[20]) && pin.unpin
  end
end
