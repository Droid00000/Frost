# frozen_string_literal: true

module Moderation
  # Base module for link spam actions.
  module LinkSpam
    extend SpamFactory

    # Fetch a user's storage bucket.
    # @param key [#id] the user or member whose storage bucket to fetch.
    # @return [StorageBucket, nil] the member's bucket, or `nil` if it isn't big enough.
    def self.bucket(key)
      MUTEX.synchronize do
        return nil unless (bucket = BUCKET[key.id])

        bucket if bucket.full? || bucket.channel_count >= 3
      end
    end

    # Add a message to the user's storage bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message data to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough links.
      return unless (urls = extract(value.message))

      # Add the message and the URL to the storage bucket.
      make_bucket(key) && BUCKET[key.id].push(value.message, urls)
    end

    # Extract a set of URLs from a given string and convert them into {URI}.
    # @param value [String, #to_s] the string to parse and extract URLs from.
    # @Param parse [true, false] whether to return the parsed {URI} objects.
    # @return [Array<URI>, Boolean] the URLs that were pared from the provided string.
    def self.extract(value)
      links = URI::RFC2396_PARSER.extract(value.to_s).map do |url|
        # Parse the URL, ignoring any errors.
        url = URI(url) rescue next

        # Remove the www. part from the host.
        url.host = url.host.sub(/^www\./, "")

        # If we know the URL is safe, just skip it.
        next if SAFE_LINKS.include?(url.host)

        # Don't match any pointless URLs such as localhost.
        url if %w[http https].include?(url.scheme)
      end

      # only return the links if there are any.
      links.compact if links.any?
    end

    # Send the logging message to the configured log channel.
    # @param key [#id] the user or member who was actioned against.
    # @param value [Hash<Symbol => Integer, Array>] the logs to send.
    def self.logger(key, value)
      # Create the descripton for the given embed.
      embed_description = lambda do |state|
        result = format(RESPONSE[1], value[:failed], value[:deleted], key.id)
        result << "\n> **URL**: #{value[:links].map { "`#{it}`" }.join(', ')}"
        state ? ("> **Joined:** <t:#{key.joined_at.to_i}:R>\n" + result) : result
      end

      # HACK: send a raw array containg the embed data as a hash.
      BOT.send_message(CONFIG[:Moderator][:CHANNEL], '', false, [{
                         color: 10_665_982,
                         timestamp: Time.now.iso8601,
                         title: Moderation::RESPONSE[6],
                         thumbnail: { url: key.display_avatar_url },
                         footer: { text: key.display_name, icon_url: key.avatar_url },
                         description: embed_description.call(key.respond_to?(:joined_at))
                       }])
    end
  end
end
