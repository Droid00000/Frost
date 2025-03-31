# frozen_string_literal: true

module Pins
  # Archive all the pins in the current channel.
  def self.archive(data)
    # Check if we have permission to manage messages in the
    # channel we're invoking from. If we don't, we can simply
    # just return early here.
    unless data.server.bot.permission?(:manage_messages, data.channel)
      data.edit_response(content: RESPONSE[1])
      return
    end

    # Request our archive channel here. We have to do this
    # first, because we don't want to reuqest all of the
    # pins in a channel if we haven't been configured to
    # archive pins here.
    channel = Frost::Pins.channel(data)

    # Return unless we have a channel to send
    # the pinned messages to.
    unless channel.is_a?(Discordrb::Channel)
      data.edit_response(content: RESPONSE[6])
      return
    end

    # Reuqest all of our pinned messages here,
    # so we can properly begin to archive our pins.
    messages = data.channel.pins

    # Return unless we have enough pins for archival.
    # 50 is the limit and not some other configurable
    # number, but this may change one day in the future.
    unless messages.count == 50
      data.edit_response(content: RESPONSE[2])
      return
    end

    # Build out and send our messages embed here.
    channel.send_embed(messages[1].link) do |embed|
      embed.timestamp = messages[1].timestamp
      embed.description = messages[1].content
      embed.colour = messages[1].author.color if messages[1].author.respond_to?(:color)
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: messages[1].attachments.first.url) if messages[1].attachments.any?
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: messages[1].author.display_name, icon_url: messages[1].author.avatar_url)
    end

    # Finally we can return a response to the user, and unpin the
    # penultimate message in the channel we're operating on.
    data.edit_response(content: RESPONSE[4]) && messages[1].unpin
  end
end
