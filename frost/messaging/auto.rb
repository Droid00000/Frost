# frozen_string_literal: true

module Pins
  # Audits all the pins in the current event's channel.
  def self.audit(data)
    # Fetch the channel we're operating on here. We only really need to
    # request this once, as having a channel indicates that the archiver
    # was setup. This means we don't need to query the DB to check if the
    # server has setup the functionality for the archiver needlessly.
    guild, bot = Guild.new(data), data.server.bot

    # Conver our channel ID into a Discordrb object.
    channel = guild.channel ? data.bot.channel(guild.channel) : nil

    # Return unless the bot has the manage messages permissions in
    # the current event originated from.
    return unless bot.permission?(:manage_messages, data.channel)

    # Return unless we have an archive channel that we can operate on.
    return unless channel && bot.permission?(:send_messages, channel)

    # Request all of our pinned messages only once. This used to be
    # pretty spammy, because I would always request this multiple
    # times in the old version of the bot. Glad I refactored this tho.
    pins = data.channel.pins

    # Return early unless we have enough pins to begin the archival
    # process. For now this is hardcoded to 50, but I might make it
    # configurable in the future based on some feedback I got.
    return unless pins.count == 50

    # Build the embed for the message we're going to
    # be sending from the second most recently pinned
    # message in the server.
    channel.send_embed(pins[1].link) do |embed|
      embed.timestamp = pins[1].timestamp
      embed.description = pins[1].content
      embed.colour = pins[1].author.color if pins[1].author.respond_to?(:color)
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: pins[1].author.display_name, icon_url: pins[1].author.avatar_url)
      
      if pins[1].attachments.any?
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: pins[1].attachments.first.url)
      end
    end

    # If everything has worked successfully so far, then that means
    # we can safely remove the old pinned message, since the old one
    # has already been archived to the log channel.
    pins[1].unpin
  end
end
