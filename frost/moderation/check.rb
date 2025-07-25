# frozen_string_literal: true

module Moderation
  # Module for managing link spam based actions.
  module LinkSpam
    # Mutex that's mostly used when accessing buckets.
    MUTEX = Mutex.new

    # Create a way to keep track of debounced messages.
    LOGGER = Set.new

    # Used to actually track spam related messages sent.
    BUCKET = Hash.new

    # Hold the log messages in a buffer for a little bit.
    BUFFER = Hash.new { |hash, key| hash[key] = [] }

    # Regular expression used to parse URLs from string content.
    REGEXP = URI::RFC2396_PARSER.make_regexp

    # Add a message to the user's given message bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message event to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough links.
      return unless extract(value.message)

      # Ensure the user's bucket exists.
      ensure_user_bucket_exists(key.id)

      # Store the URLs seperately.
      BUCKET[key.id][0] << value.message

      # Store the channel for logging.
      BUCKET[key.id][1] << value.channel.id
    end

    # Extract a set of URLs from a given string and convert them into {URI}.
    # @param value [String, #to_s] the string to parse and extract URLs from.
    # @Param parse [true, false] whether to return the parsed {URI} objects.
    # @return [Array<URI>, nil] the URLs that were pared from the provided string.
    def self.extract(value, parse: false)
      links = URI::RFC2396_PARSER.extract(value.to_s).map { URI(it) }.filter_map do |url|
        # Remove the www. part from the host.
        url.host = url.host.sub(/^www\./, "")

        # If we know the URL is safe, just skip it.
        next if SAFE_LINKS.include?(url.host)

        # Don't match any pointless URLs such as localhost.
        url if %w[http https].include?(url.scheme)
      end

      # Return `nil` for no links.
      return nil unless links.any?

      # only return the links if `parse` isn't false.
      parse == false ? true : links
    end

    # Check if the given user is exempt from spam filtering.
    # @param user [#roles] the user or member to check for.
    def self.exempt?(user)
      return true unless user.respond_to?(:roles)

      user.roles.map(&:id).intersect?(SAFE_ROLES)
    end

    # Set the time at when the last message deletion has happened.
    # @param key [Discordrb::Member] the member to set the timestamp for.
    # @param value [Integer] the epoch of the last deleted timestamp in seconds.
    def self.last_actioned_at(key, value)
      MUTEX.synchronize { BUCKET[key.id][1] = value }
    end

    # Drain the given spam bucket, in this case delete the messages in question.
    # @param queue [Queue] the bucketed queue that should be used to drain messages.
    # @return [Hash<Integer => Array<Message>, Time>] resulting metadata about deleted messages.
    def self.delete_spam(queue)
      table = Hash.new { |table, key| table[key] = [] }

      MUTEX.synchronize do
        queue.size.times { drain_bucket(queue, table) }
      end

      # Return the results hash to the user.
      table.tap { |table| table[:time] = Time.now.to_i }
    end

    # Create a spam bucket for a given user.
    # @param user [Integer] the user to create a bucket for.
    def self.ensure_user_bucket_exists(user)
      MUTEX.synchronize { BUCKET[user] ||= [Queue.new, Set.new, nil] }
    end

    # Get a user's given message bucket.
    # @param key [Discordrb::Member] the member whose bucket to fetch.
    # @return [Queue, nil] the member's bucket, or `nil` if their bucket isn't big enough.
    def self.bucket(key)
      MUTEX.synchronize do
        return nil unless (bucket = BUCKET[key.id])

        return bucket[0] if bucket[0].size >= 3 && bucket[1].size >= 3

        return bucket[0] if bucket[2] && Time.now - Time.at(bucket[2]) <= 60
      end
    end

    # Remove a single item from the user's bucket.
    # @param queue [Queue] the user's bucket to drain.
    # @param table [Hash] the table to use for appending results.
    def self.drain_bucket(queue, table)
      table[:deleted] << (value = queue.pop.tap(&:delete)) rescue table[:failed] << value
    end

    # Remove a set of stale buckets. The delete threshold is buckets last used an hour ago.
    # @param time [Time] the `Time.now` object to use as a base for time based arithmetic in the method.
    def self.audit(time)
      MUTEX.synchronize { BUCKET.delete_if { |_, value| value[2].nil? || value[2] < (time.to_i - 3600) } }
    end

    # Accumalate multiple log messages into one.
    # @param key [Discordrb::Member] the member the log messages are for.
    # @param table [Hash] the hash with the results set for the logged messages.
    def self.debounce_logging_messages(key, table)
      # We have to use a mutex almost everywhere here.
      MUTEX.synchronize do
        # Append the result to the array.
        BUFFER[key.id] << table

        # Return if a schedule already exists, or add the new one.
        LOGGER.any?(key.id) ? return : LOGGER << key.id
      end

      # Wait a bit of time. We should prob increase this later.
      sleep(15)

      # Using a mutex again...
      MUTEX.synchronize do
        # Delete the tracker.
        LOGGER.delete(key.id)

        # Fetch the logs that we have.
        logs = BUFFER.delete(key.id)

        # Now send all the accumulated logs.
        send_spam_logs(key, logs) if logs&.any?
      end
    end

    # send the spam logs to the logging channel.
    # @param user [Discordrb::Member] the member the spam entry is for.
    # @param logs [Array<Hash>] the logs to serialize and send to the channel.
    def self.send_spam_logs(user, logs)
      # Map all of our spam links into the desired format we want.
      collect_spam_links = lambda do |state|
        links = state.flatten.flat_map { |spam| extract(spam, parse: true) }

        "\n> **URL**: #{links.uniq.map { "`#{it.to_s}`" }.first(5).join(", ")}"
      end

      # Create the descripton for the given embed.
      embed_description = lambda do |state|
        failed = logs.map { it[:failed] }.map(&:size).sum
        deleted = logs.map { it[:deleted] }.map(&:size).sum
        result = format(RESPONSE[1], failed, deleted, user.resolve_id)
        result = "#{result}#{collect_spam_links.call(logs.map { it[:deleted] })}"
        state ? ("> **Joined:** <t:#{user.joined_at.to_i}:R>\n" + result) : result
      end

      # Send the embed to the logging channel.
      BOT.channel(CONFIG[:Moderator][:CHANNEL]).send_embed do |embed|
        # Add our main "Attacment Spammer" header here.
        embed.title = Moderation::RESPONSE[6]

        # Add a small footer timestamp showing when we started purging.
        embed.timestamp = Time.at(logs.first[:time])

        # Create the actual description with important logging information.
        embed.description = embed_description.call(user.respond_to?(:joined_at))

        # The thumbnail should either be the server avatar or the user avatar of the spammer.
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: user.display_avatar_url)

        # Finally, add the footer. This is going to contain the display name of the user we just purged.
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: user.display_name, icon_url: user.avatar_url)
      end
    end
  end

  # Module for managing attachment spam based actions.
  module FileSpam
    # Mutex that's mostly used when accessing buckets.
    MUTEX = Mutex.new

    # Create a way to keep track of debounced messages.
    LOGGER = Set.new

    # Used to actually track spam related messages sent.
    BUCKET = Hash.new

    # Hold the log messages in a buffer for a little bit.
    BUFFER = Hash.new { |hash, key| hash[key] = [] }

    # Add a message to the user's given message bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message event to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough attachments.
      return if value.message.attachments.size < 3

      # Ensure the user's bucket exists.
      ensure_user_bucket_exists(key.id)

      BUCKET[key.id][0] << value.message
    end

    # Check if the given user is exempt from spam filtering.
    # @param user [#roles] the user or member to check for.
    def self.exempt?(user)
      return true unless user.respond_to?(:roles)

      user.roles.map(&:id).intersect?(SAFE_ROLES)
    end

    # Set the time at when the last message deletion has happened.
    # @param key [Discordrb::Member] the member to set the timestamp for.
    # @param value [Integer] the epoch of the last deleted timestamp in seconds.
    def self.last_actioned_at(key, value)
      MUTEX.synchronize { BUCKET[key.id][1] = value }
    end

    # Drain the given spam bucket, in this case delete the messages in question.
    # @param queue [Queue] the bucketed queue that should be used to drain messages.
    # @return [Hash<Integer => Array<Message>, Time>] resulting metadata about deleted messages.
    def self.delete_spam(queue)
      table = Hash.new { |table, key| table[key] = [] }

      MUTEX.synchronize do
        queue.size.times { drain_bucket(queue, table) }
      end

      # Return the results hash to the user.
      table.tap { |table| table[:time] = Time.now.to_i }
    end

    # Create a spam bucket for a given user.
    # @param user [Integer] the user to create a bucket for.
    def self.ensure_user_bucket_exists(user)
      MUTEX.synchronize { BUCKET[user] ||= [Queue.new, nil] }
    end

    # Get a user's given message bucket.
    # @param key [Discordrb::Member] the member whose bucket to fetch.
    # @return [Queue, nil] the member's bucket, or `nil` if their bucket isn't big enough.
    def self.bucket(key)
      MUTEX.synchronize do
        return nil unless (bucket = BUCKET[key.id])

        return bucket.first if bucket[0].length >= 3

        return bucket.first if bucket[1] && Time.now - Time.at(bucket[1]) <= 60
      end
    end

    # Remove a single item from the user's bucket.
    # @param queue [Queue] the user's bucket to drain.
    # @param table [Hash] the table to use for appending results.
    def self.drain_bucket(queue, table)
      table[:deleted] << (value = queue.pop.tap(&:delete)) rescue table[:failed] << value
    end

    # Remove a set of stale buckets. The delete threshold is buckets last used four or more days ago.
    # @param time [Time] the `Time.now` object to use as a base for time based arithmetic in the method.
    def self.audit(time)
      MUTEX.synchronize { BUCKET.delete_if { |_, value| value[1].nil? || value[1] < (time.to_i - 3600) } }
    end

    # Accumalate multiple log messages into one.
    # @param key [Discordrb::Member] the member the log messages are for.
    # @param table [Hash] the hash with the results set for the logged messages.
    def self.debounce_logging_messages(key, table)
      # We have to use a mutex almost everywhere here.
      MUTEX.synchronize do
        # Append the result to the array.
        BUFFER[key.id] << table

        # Return if a schedule already exists, or add the new one.
        LOGGER.any?(key.id) ? return : LOGGER << key.id
      end

      # Wait a bit of time. We should prob increase this later.
      sleep(15)

      # Using a mutex again...
      MUTEX.synchronize do
        # Delete the tracker.
        LOGGER.delete(key.id)

        # Fetch the logs that we have.
        logs = BUFFER.delete(key.id)

        # Now send all the accumulated logs.
        send_spam_logs(key, logs) if logs&.any?
      end
    end

    # send the spam logs to the logging channel.
    # @param user [Discordrb::Member] the member the spam entry is for.
    # @param logs [Array<Hash>] the logs to serialize and send to the channel.
    def self.send_spam_logs(user, logs)
      # Create the descripton for the given embed.
      embed_description = lambda do |state|
        failed = logs.map { |log| log[:failed] }.map(&:size).sum
        deleted = logs.map { |log| log[:deleted] }.map(&:size).sum
        result = format(RESPONSE[1], failed, deleted, user.resolve_id)
        state ? ("> **Joined:** <t:#{user.joined_at.to_i}:R>\n" + result) : result
      end

      # Send the embed to the logging channel.
      BOT.channel(CONFIG[:Moderator][:CHANNEL]).send_embed do |embed|
        # Add our main "Attacment Spammer" header here.
        embed.title = Moderation::RESPONSE[5]

        # Add a small footer timestamp showing when we started purging.
        embed.timestamp = Time.at(logs.first[:time])

        # Create the actual description with important logging information.
        embed.description = embed_description.call(user.respond_to?(:joined_at))

        # The thumbnail should either be the server avatar or the user avatar of the spammer.
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: user.display_avatar_url)

        # Finally, add the footer. This is going to contain the display name of the user we just purged.
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: user.display_name, icon_url: user.avatar_url)
      end
    end
  end
end
