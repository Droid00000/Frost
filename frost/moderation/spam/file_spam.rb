# frozen_string_literal: true

module Moderation
  # Module for dealing with link spam.
  module FileSpam
    extend SpamFactory

    # Add a message to the user's storage bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message data to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough files.
      return unless value.message.attachments.size >= 3

      # Add the message data to the user's storage bucket.
      make_bucket(key) && BUCKET[key.id].push(value.message)
    end

    # Send the logging message to the configured log channel.
    # @param key [#id] the user or member who was actioned against.
    # @param value [Hash<Symbol => Integer, Array>] the logs to send.
    def self.logger(key, value)
      # Create the descripton for the given embed.
      embed_description = lambda do |state|
        result = format(RESPONSE[1], value.failed, value.deleted, user.id)
        state ? ("> **Joined:** <t:#{key.joined_at.to_i}:R>\n" + result) : result
      end

      # HACK: send a raw array containg the embed data as a hash.
      BOT.send_message(CONFIG[:Moderator][:CHANNEL], "", false, [{
                         color: 10_665_982,
                         timestamp: Time.now.iso8601,
                         title: Moderation::RESPONSE[5],
                         thumbnail: { url: key.display_avatar_url },
                         footer: { text: key.display_name, icon_url: key.avatar_url },
                         description: embed_description.call(key.respond_to?(:joined_at))
                       }])
    end
  end
end
