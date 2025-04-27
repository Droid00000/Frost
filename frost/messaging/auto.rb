# frozen_string_literal: true

module Pins
  # Audits all the pins in the current event's channel.
  def self.audit(data)
    guild, bot = [Guild.new(data), data.server.bot]

    channel = guild.channel ? bot.channel(guild.channel) : nil

    return unless bot.permission?(:manage_messages, data.channel)

    return unless channel && bot.permission?(:send_messages, channel)

    pins = data.channel.pins

    return unless pins.size == 50

    channel.send_embed(pins[1].link) do |embed|
      embed.timestamp = pins[1].timestamp
      embed.description = pins[1].content
      embed.colour = pins[1].author.color if pins[1].author.respond_to?(:color)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: pins[1].author.display_name, icon_url: pins[1].author.avatar_url)

      if pins[1].attachments.any?
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: pins[1].attachments.first.url)
      end
    end

    pins[1].unpin
  end
end
