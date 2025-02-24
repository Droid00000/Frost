# frozen_string_literal: true

module Pins
  # Audits all the pins in the current event's channel.
  def self.audit(data)
    return unless data.channel.pins.count == 50 && Frost::Pins.get(data)

    channel, pin = Frost::Pins.channel(data), data.channel.pins[1]

    channel.send_embed do |embed|
      embed.colour = UI[2]
      embed.timestamp = pin.timestamp
      embed.description = pin.content
      embed.add_field(name: "Source", value: "[Jump!](#{pin.link})")
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: pin.attachments.first.url) if pin.attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: pin.author.display_name, icon_url: pin.author.avatar_url)
    end

    pin.unpin
  end
end
