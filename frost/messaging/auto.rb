# frozen_string_literal: true

module Pins
  # Audits all the pins in the current event's channel.
  def self.audit(data)
    pins, channel = data.channel.pins, Frost::Pins.channel(data)

    return unless data.server.bot.permission?(:manage_messages, data.channel)

    return unless pins.count == 50 && channel && data.server.bot.permission?(:send_messages, channel)

    channel.send_embed(pins[1].link) do |embed|
      embed.timestamp = pins[1].timestamp
      embed.description = pins[1].content
      embed.colour = pins[1].author.color if pins[1].author.respond_to?(:color)
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: pins[1].attachments.first.url) if pins[1].attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: pins[1].author.display_name, icon_url: pins[1].author.avatar_url)
    end

    pins[1].unpin
  end
end
