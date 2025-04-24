# frozen_string_literal: true

module Pins
  # Archive all the pins in the current channel.
  def self.archive(data)
    unless data.server.bot.permission?(:manage_messages, data.channel)
      data.edit_response(content: RESPONSE[1])
      return
    end

    guild = Guild.new(data)

    channel = guild.blank? ? nil : data.bot.channel(guild.channel)

    unless channel
      data.edit_response(content: RESPONSE[6])
      return
    end

    unless data.server.bot.permission?(:manage_messages, channel)
      data.edit_response(content: RESPONSE[1])
      return
    end

    messages = data.channel.pins

    unless messages.count == 50
      data.edit_response(content: RESPONSE[2])
      return
    end

    channel.send_embed(messages[1].link) do |embed|
      embed.timestamp = messages[1].timestamp
      embed.description = messages[1].content
      embed.colour = messages[1].author.color if messages[1].author.respond_to?(:color)
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: messages[1].attachments.first.url) if messages[1].attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: messages[1].author.display_name, icon_url: messages[1].author.avatar_url)
    end

    data.edit_response(content: RESPONSE[4]) && messages[1].unpin
  end
end
