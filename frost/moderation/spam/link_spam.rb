# frozen_string_literal: true

module Moderation
  # Module for dealing with link spam.
  module LinkSpam
    extend SpamFactory

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
    # @return [Array<URI>] the URLs that were pared from the provided string.
    def self.extract(value)
      links = URI::RFC2396_PARSER.extract(value.to_s).map do |url|
        # Parse the URL, ignoring any errors.
        url = URI(url) rescue next

        # Sometimes the host part can be nil.
        next if url.host.nil?

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
        result = format(RESPONSE[3], value.deleted, key.id)
        result << "\n> **URL**: #{value.links.map { "`#{it}`" }.join(', ')}"
        state ? ("> **Joined:** <t:#{key.joined_at.to_i}:R>\n" + result) : result
      end

      # HACK: send a raw array containg the embed data as a hash.
      BOT.send_message(CONFIG[:Moderator][:CHANNEL], "", false, [{
                         color: 10_665_982,
                         timestamp: Time.now.iso8601,
                         title: Moderation::RESPONSE[6],
                         thumbnail: { url: key.display_avatar_url },
                         footer: { text: key.display_name, icon_url: key.avatar_url },
                         description: embed_description.call(key.respond_to?(:joined_at))
                       }])
    end

    # Check if the given user is exempt from spam filtering.
    # @param user [#roles] the user or member to check for.
    # @return [true, false] whether the user is exempt.
    def self.exempt?(user)
      return true unless user.respond_to?(:roles)

      user.roles.map(&:id).intersect?(SAFE_ROLES)
    end

    # Fetch a user's storage bucket.
    # @param key [#id] the user or member whose storage bucket to fetch.
    # @return [StorageBucket, nil] the member's bucket, or `nil` for no bucket.
    def self.bucket(key)
      MUTEX.synchronize do
        return nil unless (bucket = BUCKET[key.id])

        bucket if bucket.full? || bucket.channel_count >= 3
      end
    end

    # Ensure a bucket exists for the given user.
    # @param user [#id] the user or member to create a bucket for.
    # @return [StorageBucket] the created storage bucket for the user.
    def self.make_bucket(user)
      MUTEX.synchronize { BUCKET[user.id] ||= StorageBucket.new }
    end

    # Remove any dead buckets. The removal threshold is one hour (3600s).
    # @return [void] this method does not return usable data for the caller.
    def self.audit_buckets
      MUTEX.synchronize { BUCKET.delete_if { |_, value| value.dead? } }
    end

    # Drain the provided storage bucket.
    # @param bucket [StorageBucket] the storage bucket which should be drained.
    # @return [Hash<Symbol => Integer, Array>] the results of the message deletion.
    def self.delete_spam(bucket)
      results = Hash.new

      MUTEX.synchronize do
        bucket.each do |item|
          (results[:deleted] ||= 0) += 1 if item.delete rescue nil

          (results[:links] ||= []).push(*item.uris) if item.uris.any?
        end
      end

      results
    end

    # Merge multiple logging messages sent within a short time period into one.
    # @param user [#id] the user or member to create a logging bucket for.
    # @param value [Hash] the log data such as deleted message to log.
    def self.debounced_logger(user, value)
      MUTEX.synchronize do
        # Add the log message to the user's log stash
        LOGGER[user.id] << value

        # If a debounce is already in progress, don't start another.
        LOGGER[user.id].bounced? ? return : LOGGER[user.id].bounced = true
      end

      # Remove the entry entirely, since the user usually gets banned.
      sleep(66) && MUTEX.synchronize { logger(user, LOGGER.delete(user.id)) }
    end
  end
end
